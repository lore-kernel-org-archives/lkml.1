Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbXFZEdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbXFZEdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 00:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXFZEdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 00:33:42 -0400
Received: from mail.suse.de ([195.135.220.2]:57735 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbXFZEdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 00:33:41 -0400
From: Neil Brown <neilb@suse.de>
To: Graeme Sheppard <nodes@rillion.net>
Date: Tue, 26 Jun 2007 14:33:32 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18048.38684.330100.529424@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Patent or not patent a new idea
In-Reply-To: message from Graeme Sheppard on Tuesday June 26
References: <46803772.7020408@rillion.net>
	<46806CCB.6020708@rillion.net>
	<18048.30679.872740.744997@notabene.brown>
	<468085E9.70804@rillion.net>
	<18048.35410.896207.686311@notabene.brown>
	<46809495.6000109@rillion.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday June 26, nodes@rillion.net wrote:
> 
> Thanks for the brief howto there. I'll install the mdadm suite and
> experiment. It seems like a userspace driver?

mdadm is a userspace tool for managing the 'md' driver which is in the
linux kernel.

> > I don't know what you mean by '2'.
> 
> 2 meant in the way that a driver for a PC raid card is not much use on
> a Sparc.

Ahh... That is one of the great things about Linux.  You code in C,
and the driver works on every architecture (providing you are
reasonably careful, and the arch actually supports the hardware). :-)

NeilBrown
