Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968622Ab0B0Qty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:49:54 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:52748 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S968594Ab0B0Qtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:49:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZQZmxhmpG8LfLaR/U+vSuBcf8PIf2+ZefUnHvHOK+jo5Yp1DWADSCPGetxXVoLKC3yNQV9uHiRs2QakeJXKeGKt4S4f2e3IeXWURPKEV5u9duUDGSVX1af0YW9w1RIMs;
Date: Sat, 27 Feb 2010 08:50:29 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/pci changes for v2.6.34
Message-ID: <20100227085029.72318b20@jbarnes-piketon>
In-Reply-To: <20100227163915.GA12701@elte.hu>
References: <20100227163915.GA12701@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Feb 2010 17:39:15 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> Linus,
> 
> Please pull the latest x86-pci-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> x86-pci-for-linus
> 
> Jesse, the PCI bits were fine to you, right?

Yeah, those were some UV VGA changes iirc, fine with me.

-- 
Jesse Barnes, Intel Open Source Technology Center
