Return-Path: <linux-kernel-owner+w=401wt.eu-S1760624AbXHXUvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624AbXHXUvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 16:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbXHXUvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 16:51:45 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:44787
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754385AbXHXUvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 16:51:45 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] include linux/pagemap.h in asm-generic/tlb.h
Date: Fri, 24 Aug 2007 15:51:41 -0500
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
References: <20070824184616.GA9442@c2.user-mode-linux.org>
In-Reply-To: <20070824184616.GA9442@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241551.41628.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2007 1:46:16 pm Jeff Dike wrote:
> [ This looks non-urgent to me ]
>
> Without linux/pagemap.h, asm-generic/tlb.h is missing declarations of
> page_cache_release and release_pages.

It may be non-urgent to you, but it still broke my build. :)

Acked-by: Rob Landley <rob@landley.net>

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
