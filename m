Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbXJJUJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbXJJUJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 16:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbXJJUJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 16:09:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40714 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbXJJUJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 16:09:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <470D3172.5090006@s5r6.in-berlin.de>
Date: Wed, 10 Oct 2007 22:09:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Matt LaPlante <kernel1@cyberdogtech.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: (resubmitting) typo fixes for 2.6.23
References: <20071009181355.3ae1cb3b.kernel1@cyberdogtech.com>
In-Reply-To: <20071009181355.3ae1cb3b.kernel1@cyberdogtech.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt LaPlante wrote:
[...]
> this is a consolidation of a couple old missed patches, it touches
> both Kconfigs and documentation texts.

As a side note:  Submissions which touch multiple files are more
readable if prepended by the diffstat.  Thanks,
-- 
Stefan Richter
-=====-=-=== =-=- -=-=-
http://arcgraph.de/sr/
