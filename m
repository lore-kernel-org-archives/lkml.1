Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYIHXRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYIHXRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 19:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYIHXRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 19:17:22 -0400
Received: from khc.piap.pl ([195.187.100.11]:49202 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbYIHXRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 19:17:22 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org>
	<alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
	<48C56D60.7010405@zytor.com> <20080908114619.741b6786@infradead.org>
	<48C57439.3040903@zytor.com> <20080908190249.GA21998@elte.hu>
	<alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 09 Sep 2008 01:17:19 +0200
In-Reply-To: <alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org> (Linus Torvalds's message of "Mon\, 8 Sep 2008 12\:30\:02 -0700 \(PDT\)")
Message-ID: <m3vdx6xm68.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

>  - "modern 32-bit": PPro and better. Can take CMOV, MMX and TSC for 
>    granted.

VIA C3 (Samuel 2/Ezra, 600 - 1000 MHz?, common on VIA EPIA-*: home
theatres etc) can't CMOV.
-- 
Krzysztof Halasa
