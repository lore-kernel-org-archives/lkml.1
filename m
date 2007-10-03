Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbXJCI5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbXJCI5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbXJCI4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:56:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:61041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbXJCI4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:56:54 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [patch 2/2] getattr - fill the size of FIFOs
To: Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-fsdevel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Wed, 03 Oct 2007 10:55:46 +0200
References: <99UcC-5uM-51@gated-at.bofh.it> <99UcC-5uM-49@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Id01C-0000hm-3Z@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+U/8yULm6NJK82tRLbi3A3hJ/YmIXWuotLryP
 nb29PIsSvg4pW08dlTXD6IMo9czkIPiuRA3wyp4ukUniUzFoXS
 RtJzLOiE+YaUKalKRV6AA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> wrote:

> [PATCH]: Fill the size of FIFOs
> 
> Instead of reporting 0 in size when stating() a 

FIFO
-- 
Whenever you have plenty of ammo, you never miss. Whenever you are low on
ammo, you can't hit the broad side of a barn.

Friﬂ, Spammer: v@.cC.7eggert.dyndns.org fth@xU.7eggert.dyndns.org
