Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbXITPnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbXITPnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 11:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbXITPnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 11:43:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44403 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbXITPnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 11:43:17 -0400
Date: Thu, 20 Sep 2007 21:15:56 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Charles N Wyble <charles@thewybles.com>
cc: Andi Kleen <ak@suse.de>, virtualization@lists.linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>,
       Anthony Liguori <aliguori@us.ibm.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Time to make CONFIG_PARAVIRT non-experimental.
In-Reply-To: <46F034A8.2070801@thewybles.com>
Message-ID: <alpine.LFD.0.999.0709202110150.18597@enigma.security.iitk.ac.in>
References: <1189747054.7262.34.camel@localhost.localdomain>
 <200709181257.41530.ak@suse.de> <46F02F50.5000001@thewybles.com>
 <200709182220.27311.ak@suse.de> <46F034A8.2070801@thewybles.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Sep 2007, Charles N Wyble wrote:
> 
> Andi Kleen wrote:
> > 
> > Besides it's bad taste and taste is very important.
> 
> Well it's bad taste for you (one person).

FWIW, my opinion is the same as Andi's here. Please, let's avoid this
disease -- unless *absolutely* required, stuff shouldn't be "default y".
