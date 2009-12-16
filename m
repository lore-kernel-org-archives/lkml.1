Return-Path: <linux-kernel-owner+w=401wt.eu-S964821AbZLPUh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821AbZLPUh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 15:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935495AbZLPUh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 15:37:28 -0500
Received: from outbound-mail-101.bluehost.com ([69.89.22.11]:36042 "HELO
	outbound-mail-101.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935492AbZLPUh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 15:37:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=tVxMfC7yVkaT7pKxcjjpAE9Wqt+KLRhL6w+fBdRsKf9bDJDq8PVCgV9HvT0Mq2+9dMYsSJsRL4k2jpK4IV+mmJgdbHZI/Atxfs5kXYbOHjvf+x6/kNvlro5kkhPELRxX;
Date: Wed, 16 Dec 2009 12:37:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/7] x86: move range related operation to one file
Message-ID: <20091216123706.571bc92d@jbarnes-piketon>
In-Reply-To: <4B22D71E.3010309@kernel.org>
References: <4B22D71E.3010309@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you describe this series?  Something about merging the x86_64 and
i386 code it looks like?  And going through the same paths to read out
the root bridge info on both architectures?

I'm still nervous about the bridge and hotplug changes, I'll go through
them again.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
