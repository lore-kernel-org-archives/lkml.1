Return-Path: <linux-kernel-owner+w=401wt.eu-S965492AbXAXHPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965492AbXAXHPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 02:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965493AbXAXHPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 02:15:17 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:33060 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965492AbXAXHPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 02:15:15 -0500
Date: Wed, 24 Jan 2007 16:13:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] seq_file conversion: APM on arm
Message-ID: <20070124071337.GA21110@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@osdl.org>,
	Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
	rmk@arm.linux.org.uk, Ralf Baechle <ralf@linux-mips.org>
References: <20070115205935.GA5010@martell.zuzino.mipt.ru> <20070123164541.42faf54e.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070123164541.42faf54e.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 04:45:41PM -0800, Andrew Morton wrote:
> There is an ongoing desultory effort from Ralf to unify the ARM and MIPS
> APM implementations.  Independently converting them both to use seqfile
> at this stage might muck that up.   Ralf, talk to me?

What happened with this anyways? As soon as I got the conversion for SH
ready it was silently dropped from -mm. Is there anything that this is
still waiting on?
