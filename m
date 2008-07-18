Return-Path: <linux-kernel-owner+w=401wt.eu-S1757761AbYGRVhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbYGRVhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 17:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbYGRVhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 17:37:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57950 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756265AbYGRVhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 17:37:07 -0400
Message-ID: <48810CEC.6020500@zytor.com>
Date: Fri, 18 Jul 2008 14:36:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386
References: <4880AC00.76E4.0078.0@novell.com>
In-Reply-To: <4880AC00.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
> former in ioremap's phys_addr_valid() check also on 32bit/PAE.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Applied to x86/cpu, thanks!

	-hpa
