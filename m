Return-Path: <linux-kernel-owner+w=401wt.eu-S965051AbXCOD65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051AbXCOD65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 23:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965049AbXCOD65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 23:58:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:33659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965044AbXCOD64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 23:58:56 -0400
Date: Thu, 15 Mar 2007 04:58:39 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [patch 2/5] fs: introduce new aops and infrastructure
Message-ID: <20070315035838.GB15069@wotan.suse.de>
References: <20070314112529.13798.35417.sendpatchset@linux.site> <20070314112540.13798.97719.sendpatchset@linux.site> <200703142246.27167.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703142246.27167.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 10:46:25PM +0100, Mariusz Kozlowski wrote:
> Hello, 
> 
> 	I guess no need to define 'ret' twice here.

[...]

Hi Mariusz,

Thanks, I'll clean that up.

Nick
