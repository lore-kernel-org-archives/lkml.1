Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbZCFLWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbZCFLWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbZCFLWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:22:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:58923 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbZCFLWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:22:33 -0500
Date: Fri, 6 Mar 2009 03:23:03 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Andreas Robinson <andr345@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Rusty Russell <rusty@rustcorp.com.au>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: fastboot kernel parameter
Message-ID: <20090306032303.12c818ce@infradead.org>
In-Reply-To: <20090306070523.GA26395@silver.sucs.org>
References: <cc43514a0902170242m5af7e511ne00f424f06a5da22@mail.gmail.com>
	<ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	<200902181528.29697.rusty@rustcorp.com.au>
	<ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	<1234952753.10531.48.camel@andreas-laptop>
	<cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
	<ac3eb2510902191755i391d4defnc5a514f4525ec6cf@mail.gmail.com>
	<1235216636.7025.1023.camel@andreas-laptop>
	<1236004353.10055.49.camel@andreas-laptop>
	<20090302082003.1bb7bdc5@infradead.org>
	<20090306070523.GA26395@silver.sucs.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009 07:05:23 +0000
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> On Mon, Mar 02, 2009 at 08:20:03AM -0800, Arjan van de Ven wrote:
> > 
> > I would strongly suggest that you turn on the async function calls
> > and
> 
> Are async calls only turned on if you boot with the "fastboot"
> commandline parameter? If so could a mention of it be added to
> kernel-parameters as I don't see anything about it when I glanced at
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/kernel-parameters.txt;h=54f21a5c262b02ef6cb4718f72b8357693197cf3;hb=HEAD
> ...
> 

that's because it's going away again in 2.6.30....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
