Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbYGXW0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbYGXW0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 18:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYGXWZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 18:25:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50601 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbYGXWZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 18:25:52 -0400
Date: Fri, 25 Jul 2008 00:25:49 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>,
       Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
       "Hans J. Koch" <hjk@linutronix.de>, hmh@hmh.eng.br,
       David Brownell <david-b@pacbell.net>, mgross@linux.intel.com,
       Ben Nizette <bn@niasdigital.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/4] IndustrialIO subsystem (ADCs, accelerometers etc)
In-Reply-To: <488763AD.4050400@gmail.com>
Message-ID: <alpine.LNX.1.10.0807250025080.11551@fbirervta.pbzchgretzou.qr>
References: <488763AD.4050400@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-07-23 19:00, Jonathan Cameron wrote:

>Dear All,
>
>The need for an industrialio subsystem was discussed in
>http://lkml.org/lkml/2008/5/20/135
>
>Firstly thanks to all the people who have contributed to the discussion
>of this in the past.
>
>In brief the intention is provide a kernel subsystem directed towards the
>handling on sensors (and later related output devices) such as ADC's,
>accelerometers and many others.

Could this be done using UIO instead?

