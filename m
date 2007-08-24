Return-Path: <linux-kernel-owner+w=401wt.eu-S1761964AbXHXQfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964AbXHXQfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbXHXQfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:35:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110AbXHXQfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:35:23 -0400
Date: Fri, 24 Aug 2007 18:35:22 +0200
From: Andi Kleen <ak@suse.de>
To: Mel Gorman <mel@skynet.ie>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [PATCH] x86 Boot NUMA kernels on non-NUMA hardware with DISCONTIG memory model
Message-ID: <20070824163521.GA16227@bingen.suse.de>
References: <20070824162814.GD26374@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824162814.GD26374@skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This reserved portion of the KVA must be PMD aligned. 

Why do they need to be PMD aligned?  

-Andi
