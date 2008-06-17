Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbYFQMyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbYFQMyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbYFQMyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:54:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36800 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797AbYFQMyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:54:39 -0400
Subject: Re: architectures with ARCH_SUPPORTS_AOUT but no binfmt_aout
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, Peter Korsgaard <jacmet@sunsite.dk>,
       linux-kernel@vger.kernel.org, dhowells@redhat.com, andi@firstfloor.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>, ysato@users.sourceforge.jp,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20080617123717.GC10598@uranus.ravnborg.org>
References: <1213604973-7073-1-git-send-email-jacmet@sunsite.dk>
	 <1213617663.26255.708.camel@pmac.infradead.org>
	 <20080616121727.GB10854@cs181133002.pp.htv.fi>
	 <1213619214.26255.721.camel@pmac.infradead.org>
	 <20080617084235.GA20169@cs181133002.pp.htv.fi>
	 <1213696004.26255.960.camel@pmac.infradead.org>
	 <20080617101112.GE20169@cs181133002.pp.htv.fi>
	 <1213702113.26255.996.camel@pmac.infradead.org>
	 <20080617122346.GA10598@uranus.ravnborg.org>
	 <1213705749.26255.1027.camel@pmac.infradead.org>
	 <20080617123717.GC10598@uranus.ravnborg.org>
Content-Type: text/plain
Date: Tue, 17 Jun 2008 13:54:21 +0100
Message-Id: <1213707261.26255.1038.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-17 at 14:37 +0200, Sam Ravnborg wrote:
> I know and I know.
> If someone did the janitorial effort and converted all the
> per-arch defined symbols to one single definiton
> and select the list would grow rapidly.

http://git.infradead.org/users/dwmw2/aout-2.6.git?a=commitdiff;h=e75fd00c

They're still not in alphabetical order, but I haven't made it worse :)

-- 
dwmw2

