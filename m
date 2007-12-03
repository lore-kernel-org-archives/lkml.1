Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbXLCPZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbXLCPZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXLCPZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:25:14 -0500
Received: from main.gmane.org ([80.91.229.2]:41229 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbXLCPZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:25:13 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/3] drivers/serial/uartlite.c: Add missing =?utf-8?b?b2Zfbm9kZV9wdXQ=?=
Date: Mon, 3 Dec 2007 15:18:16 +0000 (UTC)
Message-ID: <loom.20071203T151533-34@post.gmane.org>
References: <Pine.LNX.4.64.0712022105480.3361@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 68.147.67.118 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.10) Gecko/20071126 Ubuntu/7.10 (gutsy) Firefox/2.0.0.10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia <at> diku.dk> writes:
> There should be an of_node_put when breaking out of a loop that iterates
> using for_each_compatible_node.
> 
<snip>
> 
> Signed-off-by: Julia Lawall <julia <at> diku.dk>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

And this should go in for .24

g.

