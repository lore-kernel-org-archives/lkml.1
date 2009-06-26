Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbZFZT00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbZFZT00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZFZT0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:26:18 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35371 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZFZT0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:26:18 -0400
MIME-Version: 1.0
X-Originating-IP: [67.185.235.14]
In-Reply-To: <20090623213647.GP23512@game.jcrosoft.org>
References: <95818a17c2b96d3769f4e1d3de26208647111758.1245778411.git.nicolas.ferre@atmel.com>
	 <f8889fb59887a970581697beb313363a6a065606.1245778411.git.nicolas.ferre@atmel.com>
	 <20090623213647.GP23512@game.jcrosoft.org>
Date: Fri, 26 Jun 2009 12:26:20 -0700
Message-ID: <9f53b4330906261226k7375fbb4t1f6d9c2b626d129@mail.gmail.com>
Subject: Re: [PATCH 2/2] AT91: atmel-mci: Platform configuration to the the 
	atmel-mci driver
From: Robert Emanuele <rob@emanuele.us>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, pierre@ossman.eu,
       avictor.za@gmail.com, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After talking with Nicholas Ferre, we decided there were enough
changes made to the at91sam9g20-ek (eval kit) that it warranted its
own machine and related board-xxx.c file.  In addition, Atmel has
released schematics for its newest revision of the at91sam9g20-ek
(rev. D) which will go into production once their supply of rev. C
boards is sufficiently small.  The rev. D board is much different than
the previous revisions. The new machine with its board file is an
excellent base to build on once the rev. D board is released.

Thank you,

Rob Emanuele
