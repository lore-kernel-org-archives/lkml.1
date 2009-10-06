Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbZJFPpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbZJFPpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbZJFPpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:45:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757405AbZJFPpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:45:21 -0400
Date: Tue, 6 Oct 2009 08:43:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dirk Hohndel <hohndel@infradead.org>
cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <1254843242.24117.23.camel@dhohndel-mobl.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.01.0910060842450.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>  <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>  <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>  <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> 
 <1254839931.24117.9.camel@dhohndel-mobl.amr.corp.intel.com>  <alpine.LFD.2.01.0910060808220.3432@localhost.localdomain> <1254843242.24117.23.camel@dhohndel-mobl.amr.corp.intel.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Dirk Hohndel wrote:
> 
> For people simply pulling from your git tree, I think the answer is YES.

If they only pull from my git tree, why do they even care?

And why don't you use LOCALVERSION_AUTO? Did you just not know about it?

			Linus
