Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbXFZCUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbXFZCUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 22:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbXFZCUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 22:20:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48183 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbXFZCUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 22:20:24 -0400
From: Neil Brown <neilb@suse.de>
To: Graeme Sheppard <nodes@rillion.net>
Date: Tue, 26 Jun 2007 12:20:07 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18048.30679.872740.744997@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Patent or not patent a new idea
In-Reply-To: message from Graeme Sheppard on Tuesday June 26
References: <46803772.7020408@rillion.net>
	<46806CCB.6020708@rillion.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday June 26, nodes@rillion.net wrote:
> Posting it here seems the best thing to do.
> 
> To the inventor goes naming privilege and I'm calling this one softer raid.
> It is a form of storage raid implemented in software, as contrasted to
> software and hardware raid which are dependent on using required hardware.
> 
> To create a loop filesystem is straight forward. The commands are dd,
> mkfs.*, mount -o loop. Basically what I propose is that the image file is
> copied to another harddisk (in the case of ide not on the same cable) and
> it too is mounted in conjunction of the original with cooperation. When a
> read request for a block of say 100k is made, the kernel pulls 50k from
> each disk - maybe a simple doubling of throughput.

Sounds a lot like "RAIF" - ask google for details.

NeilBrown
