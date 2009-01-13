Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbZAMGFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbZAMGFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbZAMGFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:05:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZAMGE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:04:59 -0500
Date: Tue, 13 Jan 2009 01:04:40 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH 6/8] parisc irq: update parisc for new irq_desc
Message-ID: <20090113060440.GA12487@bombadil.infradead.org>
References: <20090112220519.566749000@polaris-admin.engr.sgi.com> <20090112220520.435553000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112220520.435553000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 02:05:25PM -0800, Mike Travis wrote:
> Impact: cleanup, update to new cpumask API
> 
> Irq_desc.affinity and irq_desc.pending_mask are now cpumask_var_t's
> so access to them should be using the new cpumask API.
>

ok. 
