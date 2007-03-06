Return-Path: <linux-kernel-owner+w=401wt.eu-S934087AbXCFLUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087AbXCFLUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934082AbXCFLUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:20:16 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53332 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934080AbXCFLUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:20:14 -0500
Message-ID: <45ED4E6B.50000@garzik.org>
Date: Tue, 06 Mar 2007 06:20:11 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Sivakumar Subramani <sivakumar.subramani@neterion.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make drivers/net/s2io.c:vlan_strip_flag static
References: <20070305014925.GX3441@stusta.de>
In-Reply-To: <20070305014925.GX3441@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the needlessly global vlan_strip_flag static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

applied


