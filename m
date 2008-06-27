Return-Path: <linux-kernel-owner+w=401wt.eu-S1760046AbYF0RXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046AbYF0RXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYF0RX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:23:28 -0400
Received: from [198.99.130.12] ([198.99.130.12]:41943 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYF0RX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:23:26 -0400
Date: Fri, 27 Jun 2008 12:27:31 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Peter Korsgaard <jacmet@sunsite.dk>,
       linux-kernel@vger.kernel.org, sam@ravnborg.org, dhowells@redhat.com,
       andi@firstfloor.org, "Kirill A. Shutemov" <k.shutemov@gmail.com>,
       ysato@users.sourceforge.jp, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-arch@vger.kernel.org, gerg@uclinux.org
Subject: Re: architectures with ARCH_SUPPORTS_AOUT but no binfmt_aout
Message-ID: <20080627162731.GD8381@c2.user-mode-linux.org>
References: <1213617663.26255.708.camel@pmac.infradead.org> <20080616121727.GB10854@cs181133002.pp.htv.fi> <1213619214.26255.721.camel@pmac.infradead.org> <20080617084235.GA20169@cs181133002.pp.htv.fi> <1213696004.26255.960.camel@pmac.infradead.org> <20080617101112.GE20169@cs181133002.pp.htv.fi> <1213702113.26255.996.camel@pmac.infradead.org> <20080622094907.GF27069@cs181133002.pp.htv.fi> <1214134850.2409.2.camel@shinybook.infradead.org> <20080624114643.GB16021@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624114643.GB16021@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 02:46:43PM +0300, Adrian Bunk wrote:
> I found another similar case:
> 
> X86_32 UML.
> 
> a.out is most likely working there?

Yup, if it works on the host, it'll work in UML.

     	   	 Jeff

-- 
Work email - jdike at linux dot intel dot com
