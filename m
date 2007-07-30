Return-Path: <linux-kernel-owner+w=401wt.eu-S939048AbXG3HI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939048AbXG3HI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 03:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938701AbXG3HIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 03:08:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48768 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938697AbXG3HIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 03:08:18 -0400
Date: Mon, 30 Jul 2007 12:50:31 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
cc: Michael Buesch <mb@bu3sch.de>, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] Use mutex instead of semaphore in the Host AP
 driver
In-Reply-To: <20070730054004.GI3432@traven>
Message-ID: <alpine.LFD.0.999.0707301247100.12730@enigma.security.iitk.ac.in>
References: <20070729212909.GC3432@traven> <20070729213434.GD3432@traven>
 <200707300006.42397.mb@bu3sch.de> <alpine.LFD.0.999.0707300842350.10861@enigma.security.iitk.ac.in>
 <alpine.LFD.0.999.0707300904360.10861@enigma.security.iitk.ac.in>
 <20070730054004.GI3432@traven>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, Matthias Kaehlcke wrote:

> [...]
> 
> The Host AP driver uses a semaphore as mutex. Use the mutex API
> instead of the (binary) semaphore.
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Reviewed-by: Satyam Sharma <satyam@infradead.org>
