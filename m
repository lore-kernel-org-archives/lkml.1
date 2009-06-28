Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZF1LMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZF1LMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 07:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZF1LMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 07:12:18 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51816 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbZF1LMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 07:12:17 -0400
Message-ID: <4A474EFF.5030607@cs.helsinki.fi>
Date: Sun, 28 Jun 2009 14:07:43 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: depend on HAVE_ARCH_KMEMCHECK
References: <20090628111019.GA15900@Chamillionaire.breakpoint.cc>
In-Reply-To: <20090628111019.GA15900@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Andrzej Siewior wrote:
> to make it selectable if it is available
> 
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Looks good to me! Thanks.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
