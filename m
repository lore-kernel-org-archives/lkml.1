Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbXFUQbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbXFUQbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbXFUQbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:31:17 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:52619
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbXFUQbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:31:16 -0400
Date: Thu, 21 Jun 2007 09:30:29 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Tomas Neme <lacrymology@gmail.com>
cc: Alexandre Oliva <aoliva@redhat.com>, Andrew McKay <amckay@iders.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <2e6659dd0706210553p5a854ad7yc8915818b358a27c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706210929110.31603@asgard.lang.hm>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>  <4679557C.5080907@iders.ca>
  <20070620175627.319a6c55@the-village.bc.nu>  <46797C52.4020907@iders.ca> 
 <orodjatk8x.fsf@oliva.athome.lsd.ic.unicamp.br>  <Pine.LNX.4.64.0706201412340.30395@asgard.lang.hm>
  <ord4zqrl0l.fsf@oliva.athome.lsd.ic.unicamp.br> 
 <Pine.LNX.4.64.0706202227160.31603@asgard.lang.hm> 
 <orejk5rg76.fsf@oliva.athome.lsd.ic.unicamp.br>  <Pine.LNX.4.64.0706202334420.31603@asgard.lang.hm>
 <2e6659dd0706210553p5a854ad7yc8915818b358a27c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Tomas Neme wrote:

>> >  as long as this right is not used by the software distributor to
>> >  impose restrictions on the user's ability to adapt the software to
>> >  their own needs.  The GPLv3 paragraph above makes a fair concession in
>> >  this regard, don't you agree?
>>
>>  no, one of the rules for the network is that the software must be
>>  certified, you are requireing the device to permit the software to be
>>  changed to an uncertified version.(to store credit card numbers and send
>>  them to a third party for example)
>
> Also another way of doing this is having every network ask the kernel
> for its key, and checking it. If it doesn't match a certified key,
> then not allowing you to access the network.

no, this doesn't work becouse if the software has been altered you don't 
know if the key it's giving you matches that software. it could be giving 
you the key from the unmodified software.

David Lang

