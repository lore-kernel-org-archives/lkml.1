Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbZCPLgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbZCPLgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbZCPLfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:35:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57162 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553AbZCPLfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:35:54 -0400
Date: Mon, 16 Mar 2009 12:38:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: No warning on resume with different kernel version
Message-ID: <20090316113850.GA2423@elf.ucw.cz>
References: <200903141629.05282.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903141629.05282.eike-kernel@sf-tec.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-03-14 16:28:59, Rolf Eike Beer wrote:
> Hi,
> 
> I'm sure this had worked before. And since I don't do that on a regular basis, 
> but only by accident, I have no idea when it stopped working. But with my 
> 2.6.28 kernel and everything more recent I don't get a warning if there is a 
> suspend image of a different kernel version, but simply the new kernel starts 
> and throws everything away. Is this a kernel fault or something with the 
> userspace stuff? Whom to blame for this?

Actually, it should now be possible to resume with different kernel
than the one that did the suspendding...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
