Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYDXDZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYDXDZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 23:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbYDXDZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 23:25:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:29937 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYDXDZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 23:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Yh11uhnn9wkJRv9imiSS/fUDvZZby07X9ra569FiruFnVczZEs7o3lqPtLjH/t42xeuNoybYS6pCr6jF7umzbQxSFiuSUgmWwExfx5H3ZUfiw3WxkGSM8uTt9ZvTnLmd7+Cv0WBOdj9YV8DT2EDBCCU60UTI+Jn6r9NHnJQwIyY=
Message-ID: <aa79d98a0804232025p45feb6e7t4058f2eeec88f127@mail.gmail.com>
Date: Thu, 24 Apr 2008 07:25:12 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1208990882.9212.855.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181856.m3IIuKd4007403@hera.kernel.org>
	 <1208917076.9212.721.camel@pmac.infradead.org>
	 <aa79d98a0804222118me7de773kae498479531a9585@mail.gmail.com>
	 <aa79d98a0804222159l5ae49a64n101c4b299a3242ac@mail.gmail.com>
	 <480F7C11.8040302@zytor.com> <20080423185859.GB7713@cvg>
	 <480FBA73.2090209@zytor.com>
	 <1208990882.9212.855.camel@pmac.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, lets drop these all and forget :)
