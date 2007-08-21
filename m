Return-Path: <linux-kernel-owner+w=401wt.eu-S932479AbXHUSbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbXHUSbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932152AbXHUSa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:30:58 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:43296 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932191AbXHUSa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:30:57 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Aug 2007 14:30:57 EDT
X-YMail-OSG: ha4sna4VM1nYgE1HBKSmotCHsi.ZKchSvYOsLaf10UetSsMt1ElH4fi7e8s2K1GdGcxXVxmUQw--
Date: Tue, 21 Aug 2007 11:25:05 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: drop support for gcc < 4.0
Message-ID: <20070821182505.GA20968@puku.stupidest.org>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821173550.GC30705@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 07:35:50PM +0200, Adrian Bunk wrote:

> Are there any architectures still requiring a gcc < 4.0 ?

Yes, sadly in some places (embedded) there are people with older
compiler who want newer kernels.
