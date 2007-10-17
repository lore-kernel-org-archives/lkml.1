Return-Path: <linux-kernel-owner+w=401wt.eu-S935165AbXJQU2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935165AbXJQU2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760410AbXJQU2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:28:40 -0400
Received: from www.tglx.de ([62.245.132.106]:43981 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758742AbXJQU2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:28:39 -0400
Date: Wed, 17 Oct 2007 22:28:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] [x86] Add generic GPIO support to x86
In-Reply-To: <200710161341.18609.florian.fainelli@telecomint.eu>
Message-ID: <alpine.LFD.0.9999.0710172227490.24155@localhost.localdomain>
References: <200710161341.18609.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Florian Fainelli wrote:
> This patch adds the generic GPIO support to the x86
> architecture. We do the same as for MIPS, we let
> the machine override the gpio callbacks and provide
> defaults one in mach-generic.

Can you please send patches inline and not attached ?

Thanks,

	tglx
