Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbYDXFb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbYDXFb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 01:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYDXFbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 01:31:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40722 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbYDXFbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 01:31:50 -0400
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
From: David Woodhouse <dwmw2@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <aa79d98a0804232025p45feb6e7t4058f2eeec88f127@mail.gmail.com>
References: <200804181856.m3IIuKd4007403@hera.kernel.org>
	 <1208917076.9212.721.camel@pmac.infradead.org>
	 <aa79d98a0804222118me7de773kae498479531a9585@mail.gmail.com>
	 <aa79d98a0804222159l5ae49a64n101c4b299a3242ac@mail.gmail.com>
	 <480F7C11.8040302@zytor.com> <20080423185859.GB7713@cvg>
	 <480FBA73.2090209@zytor.com> <1208990882.9212.855.camel@pmac.infradead.org>
	 <aa79d98a0804232025p45feb6e7t4058f2eeec88f127@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 06:31:46 +0100
Message-Id: <1209015106.9212.898.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-24 at 07:25 +0400, Cyrill Gorcunov wrote:
> Ok, lets drop these all and forget :)

We still want to shift the definition of X86_VM_MASK inside __KERNEL__,
don't we?

-- 
dwmw2

