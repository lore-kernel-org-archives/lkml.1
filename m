Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYD2F7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYD2F7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 01:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYD2F7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 01:59:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53385 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbYD2F7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:59:30 -0400
Message-ID: <4816B940.1080203@garzik.org>
Date: Tue, 29 Apr 2008 01:59:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Blackfin EMAC Driver: code cleanup
References: <1209095591-20920-1-git-send-email-cooloney@kernel.org> <1209095591-20920-2-git-send-email-cooloney@kernel.org>
In-Reply-To: <1209095591-20920-2-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
>  - replace specific "bf537" function or data structure name to "bfin_mac"
>  - cleanup bfin_mac_probe with error checking
>  - punt set_pin_mux function, call peripheral request/free list functions directly
> 
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

applied 1-2


