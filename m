Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbXFISFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbXFISFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 14:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbXFISFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 14:05:01 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:33732
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbXFISFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 14:05:00 -0400
Message-ID: <466AEBC4.8040409@hawkeye.stone.uk.eu.org>
Date: Sat, 09 Jun 2007 19:04:52 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 6/7] Add pr_debug_pid to kernel.h
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org> <466A5E28.2000707@hawkeye.stone.uk.eu.org> <466A625C.4030700@hawkeye.stone.uk.eu.org> <20070609180318.GB5760@martell.zuzino.mipt.ru>
In-Reply-To: <20070609180318.GB5760@martell.zuzino.mipt.ru>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> NO! We don't add macros for every debug format people use into core
> headers. I think you should stop after pr_err().

That was what I though would be the answer which is why i did this
change in the last set of patches.

Jack
