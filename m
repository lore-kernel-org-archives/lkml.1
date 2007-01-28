Return-Path: <linux-kernel-owner+w=401wt.eu-S932938AbXA1Wt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbXA1Wt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932939AbXA1Wt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:49:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:53705 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938AbXA1Wt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:49:56 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: swap: which is the maximum size allowed?
To: Eriberto <eriberto@eriberto.pro.br>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sun, 28 Jan 2007 23:43:38 +0100
References: <7IoP9-5nQ-27@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HBIkM-0001I5-9q@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX1/IeXRLWh9Qb+IbmO+UMMsN0LNaDmY56k6Fat8HVIhqgkr0GgN0nCqhe+40wAt/NNof9kPlMkMdHXilSN6ss19ayQrw8CX2VFB2E1fsknBzuw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eriberto <eriberto@eriberto.pro.br> wrote:

> I am trying understand the swap. I would like to know which is the
> maximum swap size on i386. Is 64 MB? If yes, how to know the origin of
> this "magic" number? I don't found it (Internet).

Look into the manpage of mkswap. It's 2 G x 32 swap partitions,
minus a tiny overhead.
-- 
"Whoever said the pen is mightier than the sword obviously never
encountered automatic weapons."
-Gen. Douglas MacArthur
Friﬂ, Spammer: p1xdJqpr@wIueuDz.7eggert.dyndns.org
