Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbZCVKGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbZCVKGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 06:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbZCVKGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 06:06:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50158 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZCVKGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 06:06:43 -0400
Date: Sun, 22 Mar 2009 11:06:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [Bug #12871] usb bluetooth crashes system
Message-ID: <20090322100632.GA3450@ucw.cz>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera> <l8NZ2a3iQtG.A.wE.hZTxJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <l8NZ2a3iQtG.A.wE.hZTxJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-03-21 17:39:07, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 

In the meantime I verified that btusb.c from 2.6.28 does not have the
problem, and started to do kind of manual-bisect.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
