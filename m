Return-Path: <linux-kernel-owner+w=401wt.eu-S965895AbXCPUaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965895AbXCPUaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965904AbXCPUaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:30:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53158 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965895AbXCPUaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:30:18 -0400
Subject: Re: core2 duo, interrupts: is this normal?
From: Arjan van de Ven <arjan@infradead.org>
To: Norberto Bensa <nbensa@gmx.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200703152224.54607.nbensa@gmx.net>
References: <200703152224.54607.nbensa@gmx.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 16 Mar 2007 21:28:53 +0100
Message-Id: <1174076933.3538.172.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 22:24 -0300, Norberto Bensa wrote:
> Hello,
> 
> is this output, normal? I meant, why counters on CPU1 is zero? Isn't this 
> balanced?

try running irqbalance from http://www.irqbalance.org


