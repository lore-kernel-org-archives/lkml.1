Return-Path: <linux-kernel-owner+w=401wt.eu-S1750766AbXBKSEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750766AbXBKSEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbXBKSEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:04:48 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:34962 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbXBKSEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:04:33 -0500
Date: Sun, 11 Feb 2007 18:01:57 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Davide Libenzi <davidel@xmailserver.org>, linux-mips@linux-mips.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070211180157.GA21492@linux-mips.org>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <1171042535.29713.96.camel@pmac.infradead.org> <20070209134516.2367a7aa.akpm@linux-foundation.org> <1171058342.29713.136.camel@pmac.infradead.org> <Pine.LNX.4.64.0702091442230.2786@alien.or.mcafeemobile.com> <20070210102205.GB8145@osiris.boeblingen.de.ibm.com> <1171103527.29713.228.camel@pmac.infradead.org> <20070210213447.GB9116@linux-mips.org> <20070211161446.GB11547@osiris.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211161446.GB11547@osiris.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 05:14:46PM +0100, Heiko Carstens wrote:

> Hmm.. so you don't need to do some fancy compat conversion for the sigset_t
> that gets passed? Why is that? I don't get it...

Ah, I finally get your point.  Yes, that needs conversion.

  Ralf
