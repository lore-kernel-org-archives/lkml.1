Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbYJIRND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbYJIRND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYJIRMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:12:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35354 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754612AbYJIRMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:12:53 -0400
Date: Thu, 9 Oct 2008 19:12:38 +0200
From: Pavel Machek <pavel@suse.cz>
To: jikos@suse.cz, kernel list <linux-kernel@vger.kernel.org>,
       linux-acpi@ucw.cz
Subject: 2.6.27-rc8: throttling broken
Message-ID: <20081009171238.GB1370@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 2.6.27-rc8 on via/fic subnotebook, throttling seems to be broken. I
can do echo 15 > /proc/acpi/processor/*/throttling, and proc file
reflects new value, but cpu still runs at same speed.

It worked on opensuse11/sled10 kernels at least...
								Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
