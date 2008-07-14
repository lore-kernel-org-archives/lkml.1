Return-Path: <linux-kernel-owner+w=401wt.eu-S1757871AbYGNUEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbYGNUEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 16:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbYGNUEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 16:04:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:54681 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbYGNUEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:04:14 -0400
Date: Mon, 14 Jul 2008 22:04:06 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Kyle McMartin <kyle@mcmartin.ca>
cc: johnpol@2ka.mipt.ru, LKML <linux-kernel@vger.kernel.org>
Subject: Re: hifn_795x in a MacMini?
In-Reply-To: <20080714195405.GA28938@phobos.i.cabal.ca>
Message-ID: <alpine.DEB.1.10.0807142203090.4469@sheep.housecafe.de>
References: <alpine.DEB.1.10.0807142056190.4469@sheep.housecafe.de> <20080714195405.GA28938@phobos.i.cabal.ca>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Provags-ID: V01U2FsdGVkX19UyZjL3E2G6Alt+zzA2Ek3j4A3qAyMsjDGEXr
 I+SEeEjR4at8/vXbVwofCmw/I4TmgHFVNeRDQbS7yp5VuB4ARH
 8MZ9G3kr1h7EItFjk16tw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Kyle McMartin wrote:
> The message is printing by the "module loading" function, which just
> registers the pci driver, not the function that actually probes a
> device. See hifn_init versus hifn_probe, in drivers/crypto/hifn_795x.c.

OK, understood now. Thanks for pointing that out!

Christian.
-- 
BOFH excuse #45:

virus attack, luser responsible
