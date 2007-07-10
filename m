Return-Path: <linux-kernel-owner+w=401wt.eu-S1759098AbXGJQQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbXGJQQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbXGJQQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:16:27 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:51050 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbXGJQQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:16:26 -0400
Date: Tue, 10 Jul 2007 09:16:25 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: "Ni@m" <niam.niam@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: vmware modules with 2.6.22
In-Reply-To: <Pine.LNX.4.64.0707101127390.11053@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0707100915330.30646@blackbox.fnordora.org>
References: <a9e22dff0707100223y5676ca63h7aaab05a660ed81d@mail.gmail.com>
 <Pine.LNX.4.64.0707101127390.11053@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Jan Engelhardt wrote:

>
> On Jul 10 2007 12:23, Ni@m wrote:
>
>> Hi! I have  problem building vmware modules with 2.6.22.
>
> Tell that VMware, this is the wrong place.
>
>> During code investigation I've notiesd that vmware modules are using
>> old sk_buff structure
>>
>> /////
>> skb->h.raw != skb->nh.raw
>> /////
>>
>> how can I modify code to be able to compile it and where can I read
>> migration guide for sk_buff?
>
> Get http://platan.vc.cvut.cz/ftp/pub/vmware/vmware-any-any-update110.tar.gz

Is there a patch for vmware tools?  They don't seem to have a download for 
the new version to use with vmware player.

-- 
"ANSI C says access to the padding fields of a struct is undefined.
ANSI C also says that struct assignment is a memcpy. Therefore struct
assignment in ANSI C is a violation of ANSI C..."
                                   - Alan Cox
