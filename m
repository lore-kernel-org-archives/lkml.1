Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbXFISGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbXFISGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 14:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbXFISGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 14:06:04 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:33741
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbXFISGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 14:06:03 -0400
Message-ID: <466AEC04.6040800@hawkeye.stone.uk.eu.org>
Date: Sat, 09 Jun 2007 19:05:56 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 2/7] Replace DPRINTK with pr_debug in alternative.c
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org> <466A5E28.2000707@hawkeye.stone.uk.eu.org> <466A600E.9020109@hawkeye.stone.uk.eu.org> <20070609180025.GA5760@martell.zuzino.mipt.ru>
In-Reply-To: <20070609180025.GA5760@martell.zuzino.mipt.ru>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> , rendering "debug-alternative" option useless.

So drop the patch entirely or change the DPRINTK macro to use pr_debug?

Jack
