Return-Path: <linux-kernel-owner+w=401wt.eu-S935038AbZLGKSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935038AbZLGKSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935029AbZLGKSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:18:22 -0500
Received: from verein.lst.de ([213.95.11.210]:38791 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934998AbZLGKSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:18:22 -0500
From: Torsten Duwe <duwe@lst.de>
Organization: LST e.V.
To: arun@linux.vnet.ibm.com
Subject: Re: [v10 PATCH 2/9]: cpuidle: cleanup drivers/cpuidle/cpuidle.c
Date: Mon, 7 Dec 2009 11:17:57 +0100
User-Agent: KMail/1.9.10
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20091202095427.GA27251@linux.vnet.ibm.com> <200912042320.01320.duwe@lst.de> <20091206051928.GA18300@linux.vnet.ibm.com>
In-Reply-To: <20091206051928.GA18300@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912071117.58163.duwe@lst.de>
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 December 2009, Arun R Bharadwaj wrote:

> Peter objected to the idea of integrating this with the old pm_idle
> because it has already caused a lot of problems on x86 and we wouldn't
> want to be doing the same mistake on POWER. The discussion related to
> that could be found here http://lkml.org/lkml/2009/8/26/233

And BenH has sketched how it should be done on ppc, in that thread:
http://lkml.org/lkml/2009/8/26/624 AFAIS this comment is still valid for v10.

Not only I would like to understand what is the conceptual idea behind the 
other changes. Nothing wrong with cleanups, but there's got to be a purpose 
and benefits.

	Torsten
