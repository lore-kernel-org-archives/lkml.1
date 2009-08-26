Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbZHZJSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbZHZJSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbZHZJSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:18:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:53245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073AbZHZJSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:18:20 -0400
Message-ID: <4A94FD58.8060207@kernel.org>
Date: Wed, 26 Aug 2009 02:16:08 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jes@sgi.com, jens.axboe@oracle.com,
       tglx@linutronix.de, mingo@elte.hu,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Avoid division by zero
References: <1250855934.7538.30.camel@twins>	 <tip-a8af7246c114bfd939e539f9566b872c06f6225c@git.kernel.org> <1251227486.7538.1174.camel@twins>
In-Reply-To: <1251227486.7538.1174.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Yinghai, Balbir, Arjan,
> 
> Could you try the below to see if that fully does away with the /0 in
> the group scheduler thing?

yes this one fix the problem.

YH
