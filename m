Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbXFIUdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbXFIUdR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbXFIUdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:33:08 -0400
Received: from khc.piap.pl ([195.187.100.11]:53020 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbXFIUdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:33:07 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
References: <20070607162251.5f291325@the-village.bc.nu>
	<m3wsyfzcpt.fsf@maximus.localdomain>
	<200706072232.37051.s0348365@sms.ed.ac.uk>
	<m3sl93zagi.fsf@maximus.localdomain> <4668AC10.9060305@zytor.com>
	<20070608012534.GB23290@havoc.gtf.org>
	<1181297513.7348.287.camel@twins>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 09 Jun 2007 22:33:03 +0200
In-Reply-To: <1181297513.7348.287.camel@twins> (Peter Zijlstra's message of "Fri, 08 Jun 2007 12:11:53 +0200")
Message-ID: <m3fy50swao.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> I agree, its easier on the eyes to have dense columns of text to read
> than having to scan all over the place.

Sure, though I don't propose writing 130 chars in each line. Tabs
don't need much scanning.
-- 
Krzysztof Halasa
