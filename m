Return-Path: <linux-kernel-owner+w=401wt.eu-S1759690AbYBSLLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690AbYBSLLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758073AbYBSLLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:11:23 -0500
Received: from mx1.melware.net ([78.47.171.162]:58504 "EHLO mx1.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757981AbYBSLLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:11:21 -0500
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2008 06:11:21 EST
Date: Tue, 19 Feb 2008 11:51:11 +0100 (CET)
From: Armin Schindler <armin@melware.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
In-Reply-To: <20080219095834.GB6940@one.firstfloor.org>
Message-ID: <alpine.DEB.0.99.0802191148040.6445@k10.melware.de>
References: <098123kjff90231nv098233rnvd908u234@garzik.org>
 <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com>
 <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org>
 <20080219094034.GD6485@one.firstfloor.org> <20080219095622.GC4164@uranus.ravnborg.org>
 <20080219095834.GB6940@one.firstfloor.org>
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Andi Kleen wrote:
> On Tue, Feb 19, 2008 at 10:56:22AM +0100, Sam Ravnborg wrote:
>>>
>>>> If noone in the isdn community step up and take some responsibility
>>>> for the current isdn drivers in Linux then we should just delete them.
>>>
>>> So you're saying anything that has no active maintainer should
>>> be immediately deleted?
>>
>> You do not recognize a provocation when you see it?
>> I wanted a reaction from the isdn community - and I got so.
>> So lets look forward.
>
> Well it was more a lie because you couldn't possibly make up to your
> threat anyways.
>
> I'm not sure either it's a good idea to try to merge mISDN if the
> maintainers don't think it is ready yet.

Without having any opinion here or understanding what the problem is, I just
want to remind everyone that ISDN in the linux kernel (isdn4linux) is not
just mISDN.
There are drivers for common devices/interfaces, the CAPI interface and of
course hardware drivers for other ISDN cards like the active ones as well.

Armin

