Return-Path: <linux-kernel-owner+w=401wt.eu-S1764680AbXJRLW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764680AbXJRLW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbXJRLWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:22:20 -0400
Received: from www.tglx.de ([62.245.132.106]:38926 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494AbXJRLWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:22:19 -0400
Date: Thu, 18 Oct 2007 13:22:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: merge init_task_32/64.c
In-Reply-To: <47169CEC.5020706@ct.jp.nec.com>
Message-ID: <alpine.LFD.0.9999.0710181321330.24155@localhost.localdomain>
References: <47169CEC.5020706@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, Hiroshi Shimamoto wrote:
> Merge init_task_32/64.c.
> Move 64bit per cpu data orig_ist to setup64.c.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Nice one ! Applied.

Thanks,
	tglx
