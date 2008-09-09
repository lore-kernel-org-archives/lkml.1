Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbYIIKYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbYIIKYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYIIKYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:24:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58194 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYIIKYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:24:33 -0400
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
From: Andi Kleen <andi@firstfloor.org>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org>
	<alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
	<48C56D60.7010405@zytor.com> <20080908114619.741b6786@infradead.org>
	<48C57439.3040903@zytor.com> <20080908190249.GA21998@elte.hu>
	<alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org>
	<m3vdx6xm68.fsf@maximus.localdomain>
Date: Tue, 09 Sep 2008 12:24:32 +0200
In-Reply-To: <m3vdx6xm68.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Tue, 09 Sep 2008 01:17:19 +0200")
Message-ID: <87d4jdty5b.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>>  - "modern 32-bit": PPro and better. Can take CMOV, MMX and TSC for 
>>    granted.
>
> VIA C3 (Samuel 2/Ezra, 600 - 1000 MHz?, common on VIA EPIA-*: home
> theatres etc) can't CMOV.

AFAIK they fixed that in newer BIOS with a microcode update. It's 
slow, but it works.

-Andi
