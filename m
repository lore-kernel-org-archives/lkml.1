Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbXAXBwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbXAXBwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 20:52:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbXAXBwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 20:52:07 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:40800 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167AbXAXBwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 20:52:06 -0500
Date: Wed, 24 Jan 2007 01:52:01 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: [PATCH] seq_file conversion: APM on arm
Message-ID: <20070124015201.GC25189@linux-mips.org>
References: <20070115205935.GA5010@martell.zuzino.mipt.ru> <20070123164541.42faf54e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070123164541.42faf54e.akpm@osdl.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 04:45:41PM -0800, Andrew Morton wrote:

> There is an ongoing desultory effort from Ralf to unify the ARM and MIPS
> APM implementations.  Independently converting them both to use seqfile
> at this stage might muck that up.   Ralf, talk to me?

I was planning to get back to this next week but since soembody noticed
this patch was still pending, why not now ;-)

  Ralf
