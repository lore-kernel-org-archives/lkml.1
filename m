Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab0AOTtb (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 14:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114Ab0AOTt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 14:49:29 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:51105 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753481Ab0AOTt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 14:49:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=EDutwNnIqkSX3/BcgsB4SegDmhJAFPficAoXjLKnAkFzUTXHpmHYhJBK9/+i4dsRM9zF5iLK/7ccl7pPGH21PXFgCHFFosNv4Djjg/kPyvf8NroYd/f4WI4XuR6YQ5h+;
Date: Fri, 15 Jan 2010 11:49:28 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 4/7] x86/pci: use u64 instead of size_t in amd_bus.c -v2
Message-ID: <20100115114928.5e565e30@jbarnes-piketon>
In-Reply-To: <4B2BE189.9060708@kernel.org>
References: <4B2BE063.4040704@kernel.org>
	<4B2BE189.9060708@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 12:09:45 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> prepare to enable it for 32bit
> 
> -v2: remove not needed cast
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 

4-6 have conflicts against my linux-next branch, can you refresh them?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
