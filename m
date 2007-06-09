Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbXFIIB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbXFIIB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbXFIIBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:01:09 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:34705
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757632AbXFIIBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:01:07 -0400
Message-ID: <466A5E28.2000707@hawkeye.stone.uk.eu.org>
Date: Sat, 09 Jun 2007 09:00:40 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 0/7] Cleanup code to replace DPRINTK with pr_debug
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
In-Reply-To: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Stone wrote:
> This patch series replaces DPRINTK with pr_debug in alternative.c,
> autofs, autofs4
> and ncpfs. A new function called pr_err is also added to keep
> functionality in
> ncpfs. The last 2 patches add support for pr_debug_pid and apply it to
> autofs4 to
> keep the output the same as the current DPRINTK statements.
> 
> All patches have been compile tested but not boot tested

Correct set of patches.

Jack

