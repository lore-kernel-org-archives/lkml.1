Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbXH3PWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbXH3PWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbXH3PWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:22:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46100 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbXH3PWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:22:41 -0400
Date: Thu, 30 Aug 2007 08:21:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Santiago L Hasenclever <tuxpoweruser@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: probable kernel Bug
Message-ID: <20070830082137.08efcd32@laptopd505.fenrus.org>
In-Reply-To: <46D6D85A.30003@gmail.com>
References: <46D6D85A.30003@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007 11:46:50 -0300
Santiago L Hasenclever <tuxpoweruser@gmail.com> wrote:

> 0c:00.0 Network controller: Broadcom Corporation Unknown device 4311
> (rev 01)

any specific reason you're using ndiswrapper rather than the native
linux driver for this device? Your oops is all over the ndiswrapper
code.....
