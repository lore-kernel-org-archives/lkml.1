Return-Path: <linux-kernel-owner+w=401wt.eu-S971489AbXFHWlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971489AbXFHWlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXFHWlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:41:04 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45252 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbXFHWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:41:03 -0400
Message-ID: <4669DADD.3020506@zytor.com>
Date: Fri, 08 Jun 2007 15:40:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
CC: linux-kernel@vger.kernel.org, raven@themaw.net
Subject: Re: [PATCH 3/7] Replace DPRINTK with pr_debug in autofs
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org> <4669D698.3010304@hawkeye.stone.uk.eu.org>
In-Reply-To: <4669D698.3010304@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Stone wrote:
> Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

Acked-By: H. Peter Anvin <hpa@zytor.com>

As far as I can tell, autofs 3 has fallen into disuse, and autofs 4/5
has matured to the point where I don't think there is any major reason
to use autofs 3 anymore.  It probably should be put on the chopping block.

	-hpa
