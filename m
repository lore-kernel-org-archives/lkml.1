Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbYBFVQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbYBFVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbYBFVQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:16:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:58014 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661AbYBFVQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:16:19 -0500
Subject: Re: tg3 broken after "PCI: Fix bus resource assignment on 32 bits
	with 64b resources"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080206100510.GA29127@localhost.sw.ru>
References: <20080204151222.GB25790@localhost.sw.ru>
	 <1202162073.7079.8.camel@pasglop> <20080205091758.GB26618@localhost.sw.ru>
	 <86802c440802050207j60385efbif6f693dc0b1fd297@mail.gmail.com>
	 <1202244592.7079.68.camel@pasglop> <20080206100510.GA29127@localhost.sw.ru>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 08:15:26 +1100
Message-Id: <1202332526.7079.86.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> BTW, "[PATCH] x86_32: fix regression caused by trim ram according to mtrr on system with 4G more RAM"
> http://marc.info/?l=linux-kernel&m=120229095121673&w=2
> fixes this box too and I have back all 4G of RAM as a bonus. :-)

You mean you no longer have a problem or does your tg3 issue still
stand ?

Ben.


