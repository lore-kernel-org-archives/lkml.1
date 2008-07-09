Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYGIUpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYGIUpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYGIUpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:45:35 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:44365 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750955AbYGIUpe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:45:34 -0400
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
References: <486CC440.9030909@garzik.org>
	<Pine.LNX.4.64.0807031353030.11033@blonde.site>
	<486CCFED.7010308@garzik.org>
	<20080703.133428.22854563.davem@davemloft.net>
	<1215118476.10393.692.camel@pmac.infradead.org>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Wed, 09 Jul 2008 17:43:54 -0300
In-Reply-To: <1215118476.10393.692.camel@pmac.infradead.org> (David Woodhouse's message of "Thu\, 03 Jul 2008 21\:54\:36 +0100")
Message-ID: <orzloq6b5h.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul  3, 2008, David Woodhouse <dwmw2@infradead.org> wrote:

> Now, can someone _please_ give me a straight response to the allegation
> that the TSO firmware on the tg3 is _optional_ anyway, and that it can
> work without it?

FTR, I got two reports from BLAG users, through Jeff Moe, that
tg3 worked fine with linux-libre, in spite of the complete absence of
tg3 firmware in there.

I don't have any specific details about the tg3 hardware in question.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
FSFLA Board Member       ¡Sé Libre! => http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
