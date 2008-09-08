Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbYIIBnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbYIIBnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 21:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYIIBnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 21:43:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:56891 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbYIIBnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 21:43:06 -0400
Date: Mon, 8 Sep 2008 11:42:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080908114234.4d2e92e5@infradead.org>
In-Reply-To: <m3vdx6xm68.fsf@maximus.localdomain>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org>
	<alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
	<48C56D60.7010405@zytor.com>
	<20080908114619.741b6786@infradead.org>
	<48C57439.3040903@zytor.com>
	<20080908190249.GA21998@elte.hu>
	<alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org>
	<m3vdx6xm68.fsf@maximus.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2008 01:17:19 +0200
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> >  - "modern 32-bit": PPro and better. Can take CMOV, MMX and TSC for 
> >    granted.
> 
> VIA C3 (Samuel 2/Ezra, 600 - 1000 MHz?, common on VIA EPIA-*: home
> theatres etc) can't CMOV.

so your cpu does not fall into this bucket......
no big deal.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
