Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbYDXSKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbYDXSKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYDXSKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:10:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38320 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbYDXSKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:10:23 -0400
Message-ID: <4810CC2F.3010600@zytor.com>
Date: Thu, 24 Apr 2008 11:06:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: vm86 - hide X86_VM_MASK from userland programs v2
References: <20080424144120.GA7717@cvg>
In-Reply-To: <20080424144120.GA7717@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> X86_VM_MASK is a kernel specific flag so lets hide it from userland programs
>  
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Looks good to me.

Acked-by: H. Peter Anvin <hpa@zytor.com>
