Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbZIKQ1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbZIKQ1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZIKQ1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:27:13 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:59612 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZIKQ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:27:12 -0400
Date: Fri, 11 Sep 2009 17:27:08 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Luming Yu <luming.yu@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [trivial PATCH] fix typo in nmi.c of apic
In-Reply-To: <3877989d0909102303m31066b01he38e8a295995c430@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0909111711360.12448@eddie.linux-mips.org>
References: <3877989d0909102303m31066b01he38e8a295995c430@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009, Luming Yu wrote:

> I came across x86/kernel/apic/nmi.c and found several typo.
> It's trivial in terms of doing nothing on changing execution logic.
> 
> Please review. If make sense, please apply.

 Not a typo, but a historical leftover I believe.  I think your change 
makes sense these days now either way.

  Maciej
