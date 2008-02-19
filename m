Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbYBSQOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbYBSQOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbYBSQOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:14:41 -0500
Received: from senator.holtmann.net ([87.106.208.187]:36394 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYBSQOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:14:41 -0500
Cc: Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Message-Id: <79536BD8-1BB6-451E-9047-EBAC37F2073E@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20080219095834.GB6940@one.firstfloor.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
Date: Tue, 19 Feb 2008 17:14:36 +0100
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <20080219094034.GD6485@one.firstfloor.org> <20080219095622.GC4164@uranus.ravnborg.org> <20080219095834.GB6940@one.firstfloor.org>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

>>>> If noone in the isdn community step up and take some responsibility
>>>> for the current isdn drivers in Linux then we should just delete  
>>>> them.
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

you can't wait until it is perfect. Then it never gets merged. The out- 
of-tree ISDN stuff has always been painful. And that was already in  
the ISDN4Linux days which were Linux 2.2 days or even earlier.

My proposal is to merge mISDN and then see what falls out. My guess it  
won't be that bad as everybody thinks and then we go from there. Next  
step is to remove ISDN4Linux since that should not be used at all  
anymore.

Regards

Marcel

