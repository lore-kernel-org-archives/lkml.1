Return-Path: <linux-kernel-owner+w=401wt.eu-S965005AbXAWOrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965005AbXAWOrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965161AbXAWOrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:47:01 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:30333 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965005AbXAWOrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:47:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sBc5sQOJl7np4adVGokOBI0d70OlltVa53qhV+JSz8c2s+8OdsYUS7phbOf8DKDlNXNH8zK3dv/ypz5OczMd6rs1AacYwmJdQ5R6AbCcyMow4wamSnHp3C8JhkIg0jv8Jn57AurGMig44oQFhC/5QE+1iLOidn5/VTij7lJiFFA=
Message-ID: <8355959a0701230646p72fb35e3je296f5c69b9d169@mail.gmail.com>
Date: Tue, 23 Jan 2007 20:16:58 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: i965 testers wanted (Re: intel-agp PM experiences)
Cc: "Pavel Machek" <pavel@ucw.cz>, andi@lisas.de, davej@codemonkey.org.uk,
       seife@suse.de
In-Reply-To: <20070123094456.GG6033@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070116135727.GA2831@elf.ucw.cz>
	 <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com>
	 <20070116142432.GA6171@elf.ucw.cz>
	 <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com>
	 <20070117004012.GA11140@rhlx01.hs-esslingen.de>
	 <20070117005755.GB6270@elf.ucw.cz>
	 <20070118115105.GA28233@rhlx01.hs-esslingen.de>
	 <20070118231650.GA5352@ucw.cz>
	 <20070122044519.GA24398@zhen-devel.sh.intel.com>
	 <20070123094456.GG6033@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/07, Pavel Machek <pavel@ucw.cz> wrote:
> > I've post a patch which trys to resolve pci config restore issue, see
> > http://lkml.org/lkml/2007/1/16/297. It resolves s3 issue with my 965G machine,
> > that my X can come back to live after s3, but I wasn't aware of the issues Andreas
> > has noted. It'll be good if more people could try this out.
>
> Ok, I guess we'd like some testing here... so that in can be fixed in
> mainline...

Pavel,

It was same with me too, there were some ACPI issues (don't remember
properly).

http://lkml.org/lkml/2007/1/17/64

I am not getting enough time to do the tests for 965 board. I can
volunteer for this ;-) Any guidelines for testing a MOBO to comply
with LKML (am new for testing, have decided to start with this 965
MOBO).

Awaiting for suggestions...

[OT] Are there any issues with 975 (have this board too, but never
tested till now)

>                                                         Pavel

Thanks,

~Akula2
