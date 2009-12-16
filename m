Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbZLPDCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbZLPDCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZLPDCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:02:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50124 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZLPDCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:02:16 -0500
Date: Wed, 16 Dec 2009 12:02:12 +0900 (JST)
Message-Id: <20091216.120212.112622365.d.hatayama@jp.fujitsu.com>
To: mhiramat@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com
Subject: Re: [RFC, PATCH 0/4] elf_core_dump(): Add extended numbering
 support
From: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
In-Reply-To: <4B27A6BC.5080402@redhat.com>
References: <20091215.114053.193686180.d.hatayama@jp.fujitsu.com>
	<4B27A6BC.5080402@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi HATAYAMA-san,
> 
> Daisuke HATAYAMA wrote:
> > Question to Maintainers
> > ========
> > 
> > I know these patches are conflicting with Hiramatsu-san's
> > (http://lkml.org/lkml/2009/11/28/143), so I am planning to remake
> > them. But now, I don't know what tree is sutable to send these
> > patches. Do you have any suggestions?
> 
> Currently, my patches are merged into Andrew's -mm tree.
> I think your patch also may be picked up to -mm tree.

I see.

So, I remake the patches for the latest -mm tree.

Thanks.

> 
> BTW, I had asked him and Ingo that is possible to copy it to
> -tip tree too, because coredump tracepoint patch depends
> on both of signal-tracepoint and the coredump parameters
> patch. However, since now signal-tracepoint patches has
> been merged to linus git tree, I assume that coredump
> tracepoint patch can be applied after -mm tree moved on
> to .33-rc1.
> 
> 
> Thank you!
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 
