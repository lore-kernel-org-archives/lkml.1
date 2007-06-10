Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbXFJCnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbXFJCnn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 22:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbXFJCnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 22:43:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35873 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbXFJCnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 22:43:37 -0400
Message-ID: <466B6556.8010500@garzik.org>
Date: Sat, 09 Jun 2007 22:43:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Peer Chen <peerchen@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, htejun <htejun@gmail.com>
Subject: Re: [PATCH] ahci: Add MCP73/MCP77 support to AHCI driver
References: <200706071805105304242@gmail.com>
In-Reply-To: <200706071805105304242@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peer Chen wrote:
> Add the MCP73/MCP77 support to ahci driver.
> The patch base on kernel 2.6.22-rc4
>  
> Signed-off-by: Peer Chen <peerchen@gmail.com>

applied

Please put comments that should not be copied into the permanent kernel 
changelog following a "---" separator, as described in 
Documentation/SubmittingPatches.  The sentence "The patch base on kernel 
2.6.22-rc4" had to be hand-edited out, before automatic patch merge 
scripts merged your patch.


