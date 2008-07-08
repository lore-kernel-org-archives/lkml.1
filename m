Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYGIOim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYGIOim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbYGIOi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:38:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1134 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756202AbYGIOiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:38:25 -0400
Date: Tue, 8 Jul 2008 16:41:45 +0200
From: Pavel Machek <pavel@suse.cz>
To: David Altobelli <david.altobelli@hp.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, tony.camuso@hp.com
Subject: Re: [PATCH][v5] HP iLO driver
Message-ID: <20080708144145.GB8694@ucw.cz>
References: <20080702153853.GA18049@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702153853.GA18049@ldl.fc.hp.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-07-02 09:38:53, David Altobelli wrote:
> A driver for the HP iLO/iLO2 management processor, which allows userspace
> programs to query the management processor.  Programs can open a channel
> to the device (/dev/hpilo/dXccbN), and use this to send/receive queries.  

No.

It allows proprietary HP app to talk to management processor.

Other programs can't use it because you did not document the
interface.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
