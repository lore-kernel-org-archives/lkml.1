Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbZHYSEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbZHYSEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZHYSEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:04:13 -0400
Received: from smtp4.ultrahosting.com ([74.213.175.253]:42524 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755500AbZHYSEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:04:12 -0400
Date: Tue, 25 Aug 2009 14:03:17 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mike Galbraith <efault@gmx.de>
cc: raz ben yehuda <raziebe@gmail.com>, riel@redhat.com, mingo@elte.hu,
       peterz@infradead.org, andrew motron <akpm@linux-foundation.org>,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <1251222993.7023.53.camel@marge.simson.net>
Message-ID: <alpine.DEB.1.10.0908251402300.17963@gentwo.org>
References: <1250983671.5688.21.camel@raz>  <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>  <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>  <1251021133.14003.172.camel@marge.simson.net> 
 <alpine.DEB.1.10.0908251122020.26329@gentwo.org> <1251222993.7023.53.camel@marge.simson.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009, Mike Galbraith wrote:

> I asked the questions I did out of pure curiosity, and that curiosity
> has been satisfied.  It's not that I find it useless or whatnot (or that
> my opinion matters to anyone but me;).  I personally find the concept of
> injecting an RTOS into a general purpose OS with no isolation to be
> alien.  Intriguing, but very very alien.

Well lets work on the isolation piece then. We could run a regular process
on the RT cpu and switch back when OS services are needed?

