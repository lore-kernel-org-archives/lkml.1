Return-Path: <linux-kernel-owner+w=401wt.eu-S1751527AbZHZPmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbZHZPmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 11:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZHZPmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 11:42:04 -0400
Received: from smtp4.ultrahosting.com ([74.213.175.253]:53882 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751004AbZHZPmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 11:42:04 -0400
Date: Wed, 26 Aug 2009 11:41:51 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: raz ben yehuda <raziebe@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>, Mike Galbraith <efault@gmx.de>,
       riel@redhat.com, mingo@elte.hu,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <1251300625.18584.18.camel@twins>
Message-ID: <alpine.DEB.1.10.0908261136590.9933@gentwo.org>
References: <1250983671.5688.21.camel@raz>  <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>  <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>  <1251021133.14003.172.camel@marge.simson.net> 
 <alpine.DEB.1.10.0908251122020.26329@gentwo.org>  <1251222993.7023.53.camel@marge.simson.net>  <alpine.DEB.1.10.0908251402300.17963@gentwo.org>  <1251227322.7538.1172.camel@twins>  <4A943A00.9080609@nortel.com>  <1251264700.7538.1178.camel@twins>
 <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop>  <1251298443.4791.7.camel@raz> <1251300625.18584.18.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Peter Zijlstra wrote:

> Why waste a whole cpu for something that could be done by part of one?

Because of latency and performance requirements

> You're bound to have interaction between the core os and these
> partitions you want, non of it different from how threads in the kernel
> would interact, other than that you're going to re-invent everything
> already present in the kernel.

The kernel interactions can be done while running on another (not
isolated) cpu.

> You don't, you make things more complex by introducing duplicate
> functionality.

The functionality does not exist. This is about new features.

> If you think the kernel is too fat and does superfluous things for your
> needs, help trim it.

Mind boogling nonsense. Please stop fantasizing and trolling.



