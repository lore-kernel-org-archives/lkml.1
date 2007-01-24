Return-Path: <linux-kernel-owner+w=401wt.eu-S1751321AbXAXMhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbXAXMhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 07:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbXAXMhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 07:37:40 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:37537 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbXAXMhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 07:37:40 -0500
Date: Wed, 24 Jan 2007 12:37:22 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Mundt <lethal@linux-sh.org>, Andrew Morton <akpm@osdl.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: [PATCH] seq_file conversion: APM on arm
Message-ID: <20070124123722.GA13946@linux-mips.org>
References: <20070115205935.GA5010@martell.zuzino.mipt.ru> <20070123164541.42faf54e.akpm@osdl.org> <20070124071337.GA21110@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124071337.GA21110@linux-sh.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 04:13:37PM +0900, Paul Mundt wrote:

> On Tue, Jan 23, 2007 at 04:45:41PM -0800, Andrew Morton wrote:
> > There is an ongoing desultory effort from Ralf to unify the ARM and MIPS
> > APM implementations.  Independently converting them both to use seqfile
> > at this stage might muck that up.   Ralf, talk to me?
> 
> What happened with this anyways? As soon as I got the conversion for SH
> ready it was silently dropped from -mm. Is there anything that this is
> still waiting on?

There was a midair collision between this patchset and a few other patches
from rmk.  Andrew applied rmk's patches and due to the conflict with my
patchset, so dropped mine which I started respinning last night until
I ran out of midnight oil.

  Ralf
