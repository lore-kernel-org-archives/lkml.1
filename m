Return-Path: <linux-kernel-owner+w=401wt.eu-S936950AbXFHBJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936950AbXFHBJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 21:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762999AbXFHBJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:09:34 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51840 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbXFHBJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:09:34 -0400
Message-ID: <4668AC10.9060305@zytor.com>
Date: Thu, 07 Jun 2007 18:08:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
References: <20070607162251.5f291325@the-village.bc.nu>	<m3wsyfzcpt.fsf@maximus.localdomain>	<200706072232.37051.s0348365@sms.ed.ac.uk> <m3sl93zagi.fsf@maximus.localdomain>
In-Reply-To: <m3sl93zagi.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Alistair John Strachan <s0348365@sms.ed.ac.uk> writes:
> 
>> I personally buy the argument that 80 cols helps remind people that they've 
>> used too many indentation depths and should redesign their code.
>> I think it's 
>> a good thing to stick to where possible, even if just from a design 
>> perspective.
> 
> How many is too many? A function with 2 "if" means 3 tabs = 24 characters
> for just indentation. Add a printk(KERN_DEBUG "\n"); and you can print
> ca. 30 characters without having to break the string. This is crazy.
> 

My big concern with the 80-column rule is that it discourages commenting.

	-hpa
