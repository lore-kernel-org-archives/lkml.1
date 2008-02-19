Return-Path: <linux-kernel-owner+w=401wt.eu-S1762923AbYBSJkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762923AbYBSJkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYBSJkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:40:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39110 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbYBSJkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:40:32 -0500
Date: Tue, 19 Feb 2008 10:40:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
Message-ID: <20080219094034.GD6485@one.firstfloor.org>
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219085033.GA1775@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 09:50:33AM +0100, Sam Ravnborg wrote:
> Only issue seems that this large ISDN user base is not very active
> in respect to Linux driver development.

They don't need to because this stuff basically works and there isn't
much new hardware anymore and no new standards and it also doesn't really
need much tuning.

Or rather the new hardware development (like Asterisk support etc.) 
seemed to be mostly done on out of tree mISDN.

> If noone in the isdn community step up and take some responsibility
> for the current isdn drivers in Linux then we should just delete them.

So you're saying anything that has no active maintainer should 
be immediately deleted?

I suspect after you would be done with that a lot of (working) code in Linux
would be gone. 

-Andi

