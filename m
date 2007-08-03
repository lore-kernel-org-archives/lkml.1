Return-Path: <linux-kernel-owner+w=401wt.eu-S1763807AbXHCPcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763807AbXHCPcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762921AbXHCPcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:32:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35723 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762932AbXHCPb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:31:59 -0400
Subject: Re: Regression in 2.6.22, clock problems on Turion with 32-bit
	kernel
From: Arjan van de Ven <arjan@infradead.org>
To: Ben Collins <ben.collins@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Tim Gardner <tim.gardner@canonical.com>
In-Reply-To: <1186150484.8105.57.camel@cunning>
References: <1186150484.8105.57.camel@cunning>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 03 Aug 2007 08:30:56 -0700
Message-Id: <1186155056.2707.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I've tried every combination of boot param revolving around clocksource
> and interrupts. The only thing that gets me booting is nolapic, but then
> again, that knocks me down to a single cpu. 

hummm.... I wonder how nolapic knows you down to a single cpu.......
that is just an entirely strange relationship.

