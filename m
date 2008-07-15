Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbYGOXen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbYGOXen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYGOXef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:34:35 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:40923 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754511AbYGOXef convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:34:35 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, rene.herman@keyaccess.nl,
       david@lang.hm, arjan@infradead.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
References: <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm>
	<20080714.185207.203328391.davem@davemloft.net>
	<487C0A12.9060906@keyaccess.nl>
	<20080714.192425.241878700.davem@davemloft.net>
	<alpine.LFD.1.10.0807141934060.3017@woody.linux-foundation.org>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Tue, 15 Jul 2008 20:33:33 -0300
In-Reply-To: <alpine.LFD.1.10.0807141934060.3017@woody.linux-foundation.org> (Linus Torvalds's message of "Mon\, 14 Jul 2008 19\:39\:03 -0700 \(PDT\)")
Message-ID: <or63r63epe.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 14, 2008, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [...] I like just making everybody do request_firmware().

> Do you call that a legal reason? Or a technical one?

\o.

Hmm, let's se...

How about legal?

If they don't budge in, you can terminate their license to Linux,
because they are distributing your GPLed work combined with software
that is not under a GPL-compatible license.

:-P :-D

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
FSFLA Board Member       ¡Sé Libre! => http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
