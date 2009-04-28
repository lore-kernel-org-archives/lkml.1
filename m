Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbZD1MJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbZD1MJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 08:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbZD1MJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 08:09:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:45828 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbZD1MJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 08:09:31 -0400
Cc: akpm@linux-foundation.org, David Miller <davem@davemloft.net>,
       mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev Development <linuxppc-dev@ozlabs.org>,
       Netdev <netdev@vger.kernel.org>
Message-Id: <D2FE35F2-E8A4-4B65-A8CE-DA8CF202EE37@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Li Yang <leoli@freescale.com>
In-Reply-To: <2a27d3730904280316l7049bddbie914907b16ccfff6@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 0/5] rapidio: adding memory mapping IO support and misc fixes
Date: Tue, 28 Apr 2009 07:06:40 -0500
References: <2a27d3730904280316l7049bddbie914907b16ccfff6@mail.gmail.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 28, 2009, at 5:16 AM, Li Yang wrote:

> The patch series add MMIO support to Linux rapidio and fix a few nits.
> The patches cross rapidio, netdev, powerpc sub-systems.  It will be
> good for them to go through one tree.  Probably Andrew?  As the
> previous rapidio patches are mostly merged by you.
>
> - Leo

When you repost use the -n option in git-format-patch so we get a  
sequence # for the patches.

Either Andrew or I can possible pick them up as long as we get the  
right maintainer ACKs.

- k
