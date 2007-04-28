Return-Path: <linux-kernel-owner+w=401wt.eu-S1030819AbXD1VWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030819AbXD1VWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030824AbXD1VWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:22:33 -0400
Received: from [81.2.110.250] ([81.2.110.250]:39188 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030819AbXD1VWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:22:32 -0400
Date: Sat, 28 Apr 2007 22:26:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21-git2] sk_buff changes break Cisco VPN client
Message-ID: <20070428222623.1deac950@the-village.bc.nu>
In-Reply-To: <5a4c581d0704281338w28227b13p52f3043a56af4945@mail.gmail.com>
References: <5a4c581d0704281338w28227b13p52f3043a56af4945@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 22:38:45 +0200
"Alessandro Suardi" <alessandro.suardi@gmail.com> wrote:

> skb_set_timestamp I can figure out, but the rest is a bit
>  too hard for me... if anyone has already an idea of how
>  to fix this, I'd be most grateful.
> 
> Cisco VPN client builds and works fine under 2.6.21 vanilla.

Perhaps if cisco included full source they could get their code merged,
in the meantime why not throw it away and use vpnclient like everyone
else ?
