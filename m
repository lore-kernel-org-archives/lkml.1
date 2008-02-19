Return-Path: <linux-kernel-owner+w=401wt.eu-S1756974AbYBSLld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbYBSLld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYBSLlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:41:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61227 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYBSLlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:41:23 -0500
Message-ID: <47BAC065.4050602@anagramm.de>
Date: Tue, 19 Feb 2008 12:41:25 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: CIJOML <cijoml@volny.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Is Infineon PEB 3332 EL supported in Linux?
References: <200802190057.42141.cijoml@volny.cz>
In-Reply-To: <200802190057.42141.cijoml@volny.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+i+AVLPRuOmcdrRHrjXjhdrgUZ6VfwgSCwwch
 V+9R8vjGQjx9vUU+fpxT/ERJjaGd0yRkBvr/bYNgd5Ab/EL1oX
 3ggvzPHHSBp32OJH077bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CIJOML schrieb:
> Hi there, 
> 
> I would like flash my D-link DVG-G1402S with linux ADM5120 port. It should be 
> possible, but I would like still use it as a SIP gateway. There is Infineon 
> PEB 3332 EL responsible for that job, so my question is if it is supported.
> BTW this router's internals photos are there:

Quick answer: No.

The VINETIC-CPE (PEB3332EL) is doing the analog voice processing and
needs DSP firmware as well as device drivers provided by Infineon.
I don't think you will get this stuff from Infineon easily.
But you can try to extract it from the current D-link firmware.
YMMV.

I could ask a friend who is working on the DSL-Chipsets at Infineon
about their code/driver policy/availability. Ping me off-list in 2 weeks,
he is on holiday right now.

Regards,

Clemens
