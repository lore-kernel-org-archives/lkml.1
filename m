Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbXFIHAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbXFIHAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 03:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbXFIHAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 03:00:00 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56457 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbXFIHAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 03:00:00 -0400
X-Sasl-enc: FJSAFtCDYMBD00pSstWsViKi/IiIyis23GtNIwMGCwLO 1181371414
Subject: Re: [PATCH 0/7] Cleanup code to replace DPRINTK with pr_debug
From: Ian Kent <raven@themaw.net>
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
Content-Type: text/plain
Date: Sat, 09 Jun 2007 14:43:26 +0800
Message-Id: <1181371406.3423.4.camel@shark.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 23:18 +0100, Jack Stone wrote:
> This patch series replaces DPRINTK with pr_debug in alternative.c,
> autofs, autofs4
> and ncpfs. A new function called pr_err is also added to keep
> functionality in
> ncpfs. The last 2 patches add support for pr_debug_pid and apply it to
> autofs4 to
> keep the output the same as the current DPRINTK statements.

And ???

Presenting patches without the reason why they are needed is not a good
policy.

Not to mention that several appear to be missing headers, I can't
believe you tested that they applied before posting them.

NACK.

Ian


