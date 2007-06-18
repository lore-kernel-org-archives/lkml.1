Return-Path: <linux-kernel-owner+w=401wt.eu-S932835AbXFRURW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbXFRURW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932777AbXFRUQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:16:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604AbXFRUQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:16:40 -0400
Message-ID: <4676E812.1050000@redhat.com>
Date: Mon, 18 Jun 2007 16:16:18 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [patch 4/8] Immediate Value - i386 Optimization; kprobes
References: <20070615202310.178466032@polymtl.ca> <4676D2A9.6090403@redhat.com> <20070618115632.7aca8c0f.akpm@linux-foundation.org> <200706182132.56559.ak@suse.de>
In-Reply-To: <200706182132.56559.ak@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2007 03:32 PM, Andi Kleen wrote:
> 
> But for 2.6.22 as a quick fix it might be better to just
> make KPROBES dependent on !DEBUG_RODATA. That would be a one liner.

Yeah, that's probably best for now.

