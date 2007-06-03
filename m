Return-Path: <linux-kernel-owner+w=401wt.eu-S1764281AbXFCGsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764281AbXFCGsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 02:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbXFCGr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 02:47:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58153 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbXFCGr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 02:47:56 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <466263FC.3000904@s5r6.in-berlin.de>
Date: Sun, 03 Jun 2007 08:47:24 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       =?ISO-8859-1?Q?Kristi?= =?ISO-8859-1?Q?an_H=F8gsberg?= 
	<krh@bitplanet.net>,
       LKML <linux-kernel@vger.kernel.org>, Marcus Better <marcus@better.se>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com>
In-Reply-To: <46559B54.80106@googlemail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Subject    : 2.6.22-rc1 suspend to RAM problem
> References : http://permalink.gmane.org/gmane.linux.power-management.general/5819
> Submitter  : Marcus Better <marcus@better.se>
> Handled-By : Stefan Richter <stefanr@s5r6.in-berlin.de>
>              Kristian Høgsberg <krh@bitplanet.net>
> Status     : caused by fw-ohci module

Fixed in Linus' tree.
-- 
Stefan Richter
-=====-=-=== -==- ---==
http://arcgraph.de/sr/
