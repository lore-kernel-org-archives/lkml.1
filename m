Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYJ3RnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYJ3RnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbYJ3RnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:43:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34908 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753194AbYJ3RnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:43:05 -0400
Date: Thu, 30 Oct 2008 18:43:00 +0100
From: Pavel Machek <pavel@suse.cz>
To: J?rn Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
Message-ID: <20081030174300.GA1773@ucw.cz>
References: <20081026124643.GA1328@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081026124643.GA1328@logfs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Main disadvantage of btrees is that they are complicated, come in a
> gazillion subtly different variant that differ mainly in the balance
> between read efficiency and write efficiency.  Comparing btrees against
> anything is a bit like comparing apples and random fruits.

:-)))))





+ * Disks have fulfilled the prerequite for a long time.  More recently DRAM

prerequisite?

+#define MAX(a, b) ((a) > (b) ? (a) : (b))

We already have that in the headers somewhere.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
