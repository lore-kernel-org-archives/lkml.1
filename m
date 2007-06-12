Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbXFLV7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbXFLV7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 17:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbXFLV7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 17:59:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:16489 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbXFLV7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 17:59:37 -0400
Date: Tue, 12 Jun 2007 23:59:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Claas Langbehn <claas@rootdir.de>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: VIA C7 / VIA PC-1 (PC2500) anyone?
In-Reply-To: <466E993D.5080308@msgid.tls.msk.ru>
Message-ID: <Pine.LNX.4.64.0706122359080.19578@fbirervta.pbzchgretzou.qr>
References: <466E65A7.3000206@msgid.tls.msk.ru>
 <5699f8f00706120344h40fe6f88vb7601c9326bd589f@mail.gmail.com>
 <466E8A5B.4080205@msgid.tls.msk.ru> <466E976D.7060103@rootdir.de>
 <466E993D.5080308@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 12 2007 17:01, Michael Tokarev wrote:
>
>Claas Langbehn wrote:
>>> Hmm.  I wonder how to *enable* it in the first place.. ;)
>>> e_powersaver.ko and acpi_cpufreq gives "No such device"
>>>
>> cat /proc/cpuinfo and have a look at the flags. Does it support "eps"?
>
>I've looked at e_powersaver sources and noticied the second test in
>init function (after checking for CPU model) - it fails on this very
>test:

Actually you may want to try longhaul.ko



	Jan
-- 
