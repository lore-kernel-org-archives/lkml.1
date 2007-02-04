Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbXBDPrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbXBDPrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 10:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbXBDPrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 10:47:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60635 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbXBDPrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 10:47:17 -0500
Subject: Re: Kernel BUG at mm/slab.c:595
From: Arjan van de Ven <arjan@infradead.org>
To: Yu-Chen Wu <g944370@oz.nthu.edu.tw>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <003801c7486c$7d862680$0100a8c0@sslabmayasky>
References: <003801c7486c$7d862680$0100a8c0@sslabmayasky>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 04 Feb 2007 16:47:12 +0100
Message-Id: <1170604032.3073.1162.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-04 at 22:55 +0800, Yu-Chen Wu wrote:
> Hi all,
> 
>            I am developing my module, but meet a bug. Is the bug created by
> me??

very likely; your module is all over the backtrace...

if you post the module source somewhere I and others will take a look to
see if there's anything obviously wrong with it...


