Return-Path: <linux-kernel-owner+w=401wt.eu-S1763195AbZFRLvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763195AbZFRLvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 07:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760955AbZFRLvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 07:51:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761918AbZFRLvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 07:51:22 -0400
Date: Thu, 18 Jun 2009 07:51:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5 -tip] x86: move common typedefs to asm/posix_types.h
Message-ID: <20090618115101.GA1671@infradead.org>
References: <1245314365.31204.7.camel@ht.satnam> <1245314443.31204.9.camel@ht.satnam> <1245314484.31204.10.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245314484.31204.10.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 02:11:24PM +0530, Jaswinder Singh Rajput wrote:
> 
> Move common typedefs to asm/posix_types.h for easy maintenance

I think at this point it would be cleaner to also move the differing
ones into asm/posix_types.h so that there's just one file to look at for
the types.

