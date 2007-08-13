Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbXHMMo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbXHMMo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939618AbXHMHYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:24:20 -0400
Received: from atlanta.zankel.net ([69.61.78.146]:2811 "EHLO
	atlanta.zankel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938042AbXHMHYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:24:18 -0400
Message-ID: <46C0071B.6040008@zankel.net>
Date: Mon, 13 Aug 2007 00:24:11 -0700
From: Christian Zankel <chris@zankel.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: joe@perches.com
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [451/2many] MAINTAINERS - TENSILICA XTENSA PORT (xtensa):
References: <46bffbe7.8UT7uMa0kiZH+b7M%joe@perches.com>
In-Reply-To: <46bffbe7.8UT7uMa0kiZH+b7M%joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

There is a slight misspelling in the arch path (the include path is 
correct, though.) It should be arch/xtensa.

joe@perches.com wrote:
> +F:	arch/extensa/
             ^^^
> +F:	include/asm-xtensa/


Cheers!
-Chris
