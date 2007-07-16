Return-Path: <linux-kernel-owner+w=401wt.eu-S932288AbXGPWb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbXGPWb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761957AbXGPWal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:30:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37316 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbXGPWai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:30:38 -0400
Message-ID: <469BF18B.9000908@garzik.org>
Date: Mon, 16 Jul 2007 18:30:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: csnook@redhat.com, atl1-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] atl1: remove irq_sem
References: <11845154092908-git-send-email-jacliburn@bellsouth.net> <1184515409355-git-send-email-jacliburn@bellsouth.net>
In-Reply-To: <1184515409355-git-send-email-jacliburn@bellsouth.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> Remove unnecessary irq_sem code.
> 
> Signed-off-by: Chris Snook <csnook@redhat.com>
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>

applied 1-5


