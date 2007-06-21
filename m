Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbXFUMyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbXFUMyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 08:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbXFUMx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 08:53:59 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:65027 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXFUMx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 08:53:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tpqjk/iM5DNVxJMVlh5MvKDiH7gcbu2mUw2MVziqb0ONSvumQ1eKuFDSlbZz+TCMYSCNw+IUaj+sRbPBF+01uYB9s07lcr+KNqdiSWOD2dU1QxzH46xV8KXWm6vcnVqCYsrYbQK4BxjhHIFOGceWm70cspfOMfgr3JmvT+Eb7uY=
Message-ID: <2e6659dd0706210553p5a854ad7yc8915818b358a27c@mail.gmail.com>
Date: Thu, 21 Jun 2007 09:53:54 -0300
From: "Tomas Neme" <lacrymology@gmail.com>
To: "david@lang.hm" <david@lang.hm>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Alexandre Oliva" <aoliva@redhat.com>, "Andrew McKay" <amckay@iders.ca>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Daniel Hazelton" <dhazelton@enter.net>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706202334420.31603@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <4679557C.5080907@iders.ca>
	 <20070620175627.319a6c55@the-village.bc.nu>
	 <46797C52.4020907@iders.ca>
	 <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm>
	 <ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm>
	 <orejk5rg76.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <Pine.LNX.4.64.0706202334420.31603@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > as long as this right is not used by the software distributor to
> > impose restrictions on the user's ability to adapt the software to
> > their own needs.  The GPLv3 paragraph above makes a fair concession in
> > this regard, don't you agree?
>
> no, one of the rules for the network is that the software must be
> certified, you are requireing the device to permit the software to be
> changed to an uncertified version.(to store credit card numbers and send
> them to a third party for example)

Also another way of doing this is having every network ask the kernel
for its key, and checking it. If it doesn't match a certified key,
then not allowing you to access the network.

Besides the fact that this would be a very costly approach, having
every network needing to update their certified keys list every time
TiVo and every other DVR vendor updates their kernels, it would also
prevent any form of modified software to give you any of the TiVo's
expected functionality: it would load, you would be able to play pong
on it, but not watch or record TV, and they can't be blamed for it,
because if the kernel's been tampered with, it might have been made so
it saves the video unencrypted on the Harddrive, and it certainly *is*
the network's right to stop you from doing so. So what the fuck do you
want from them?

T

-- 
|_|0|_|
|_|_|0|
|0|0|0|
