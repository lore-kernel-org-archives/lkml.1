Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab0AOTuA (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 14:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122Ab0AOTt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 14:49:59 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:45074 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753979Ab0AOTt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 14:49:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DCDr3uF6wCuvO/STv91Hr51UhcOzTFKlosY/8PKSMxnLMgJvROPalQtDNxtPYkV63Zh0HVRWx/+haJg+gyzN6wyduA0ROGw4vPId71Jmv6SYxJ/TcIgchiMmurXJ6T10;
Date: Fri, 15 Jan 2010 11:49:56 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/7] x86/pci: use resource_size_t in update_res -v2
Message-ID: <20100115114956.6207cfa4@jbarnes-piketon>
In-Reply-To: <4B2BE181.5090406@kernel.org>
References: <4B2BE063.4040704@kernel.org>
	<4B2BE181.5090406@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 12:09:37 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> 
> prepare to enable 32bit intel and amd bus
> 
> v2: change __init to __devinit
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---

Applied 2-3 to my linux-next branch, thanks.  (1 was already applied to
fix Jens' problem over the holidays, thanks hpa).

-- 
Jesse Barnes, Intel Open Source Technology Center
