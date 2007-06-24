Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbXFXVrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbXFXVrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbXFXVrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:47:10 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:60864 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbXFXVrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:47:09 -0400
Message-ID: <467EE583.5090804@gmail.com>
Date: Sun, 24 Jun 2007 23:43:31 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: =?ISO-8859-15?Q?Tomasz_K=3Foczko?= <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <Pine.LNX.4.64.0706242126200.11964@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0706242126200.11964@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2007 09:27 PM, Jan Engelhardt wrote:

> On Jun 24 2007 21:24, Tomasz K?oczko wrote:
>> Try to answer on question "ALSA or OSS ?" using *only* technical
>> arguments.
> 
> Ok: The OSS cs46xx driver did not support the rear 2 channels.

Not sure it's going to count as only technical in wanker language but note 
that a very important driver such as Envy24 also works decidely worse in the 
open sourced OSS. In the "module envy24 not found" sense.

Which is the same sense as anything currently available from sound/isa in fact.

Rene.
