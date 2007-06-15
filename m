Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbXFOQ1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbXFOQ1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbXFOQ1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:27:44 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:9480 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531AbXFOQ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:27:42 -0400
Date: Fri, 15 Jun 2007 18:27:41 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
cc: =?UTF-8?B?TWloYWkgRG9uyJt1?= <mihai.dontu@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux Servers comparison with Windows 2003 servers for Gaming
In-Reply-To: <4672B4A6.8020909@mandic.com.br>
Message-ID: <Pine.LNX.4.64.0706151827250.32724@fbirervta.pbzchgretzou.qr>
References: <8d6898730706150712u182f5af1h2d92030adf16d022@mail.gmail.com>
 <20070615152313.3638b4d5@the-village.bc.nu> <4672A3AA.6010705@mandic.com.br>
 <200706151753.14721.mihai.dontu@gmail.com> <4672B4A6.8020909@mandic.com.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 15 2007 12:47, Renato S. Yamane wrote:
>> 
>>   Well, here are some steps:
>>   1. boot an Ubuntu livecd
>>   2. lspci && lsmod and see what it has detected/loaded
>>   3. cd /usr/src/linux && make menuconfig
>>   4. read the help for each "set" option and see what it does (like many
>> people did in the early days). If you don't find it useful, press N.
>
> One more detail: Is better put this modules listed in lsmod as "built-in"?

It hardly makes a difference.


	Jan
-- 
