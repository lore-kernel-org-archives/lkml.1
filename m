Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbYF2Mq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbYF2Mq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 08:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbYF2Mqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 08:46:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47945 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754112AbYF2Mqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 08:46:49 -0400
Date: Sun, 29 Jun 2008 13:29:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Agner Fog <agner@agner.org>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
Message-ID: <20080629132906.611e5244@lxorguk.ukuu.org.uk>
In-Reply-To: <4865F0DA.2050906@agner.org>
References: <48626514.2040905@agner.org>
	<20080625092224.736c2541@infradead.org>
	<4862ECAB.1040402@zytor.com>
	<4864CFA5.9050901@agner.org>
	<20080627072231.7337ba18@infradead.org>
	<4865F0DA.2050906@agner.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nothing should prevent me from publishing my own driver for some special 
> purpose (in fact, I am going to do so). The open source principle would 

Go ahead but the API is *source* level and changes each release so the
ABI question doesn't happen.

> It is a disgrace that the ABI 

We don't have an ABI.

Alan
