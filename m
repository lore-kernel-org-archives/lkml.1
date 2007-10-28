Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbXJ1QWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbXJ1QWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 12:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbXJ1QWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 12:22:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35820 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXJ1QW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 12:22:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4724B71A.7020201@s5r6.in-berlin.de>
Date: Sun, 28 Oct 2007 17:21:46 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: krh@redhat.com, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] ieee1394_transactions.c: remove dead code
References: <20071028155132.GA7227@stusta.de>
In-Reply-To: <20071028155132.GA7227@stusta.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch removes dead code spotted by the Intel C Compiler.

Committed to linux1394-2.6.git, thanks.
-- 
Stefan Richter
-=====-=-=== =-=- ===--
http://arcgraph.de/sr/
