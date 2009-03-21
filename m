Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZCUVMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZCUVMy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 17:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZCUVMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 17:12:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:37799 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZCUVMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 17:12:44 -0400
Date: Sat, 21 Mar 2009 14:13:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
Message-ID: <20090321141340.3b5ffa4f@infradead.org>
In-Reply-To: <49C54D60.80306@cosmosbay.com>
References: <20090318215812.15496a86@infradead.org>
	<20090319085628.GA6167@in.ibm.com>
	<20090319071841.63334eff@infradead.org>
	<20090320020750.GA6807@linux.vnet.ibm.com>
	<20090319202032.4c971d92@infradead.org>
	<20090320044541.GE6807@linux.vnet.ibm.com>
	<20090320065058.65d01771@infradead.org>
	<20090320143104.GA6698@linux.vnet.ibm.com>
	<20090320111354.679ab53d@infradead.org>
	<20090321012746.GM6698@linux.vnet.ibm.com>
	<20090321125115.0a76ac27@infradead.org>
	<49C54D60.80306@cosmosbay.com>
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

On Sat, 21 Mar 2009 21:26:08 +0100
Eric Dumazet <dada1@cosmosbay.com> wrote:

> > 
> > (svg can be viewed with inkscape, gimp, firefox and various other
> > tools)
> > 
> > 
> 
> Interesting stuff...
> 
> I thought you mentioned i2c drivers being source of the udelays(),
>  but I cant see them in this svg, unless its async_probe_hard ?

yeah that one is doing a ton of i2c

(I'm working on optimizing the code in that area still)

> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
