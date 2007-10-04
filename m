Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbXJDMC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbXJDMC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 08:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759423AbXJDMCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 08:02:45 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:42558 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1756893AbXJDMCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 08:02:44 -0400
Message-ID: <4704D77D.1040005@ru.mvista.com>
Date: Thu, 04 Oct 2007 16:07:25 +0400
From: Andrei Konovalov <akonovalov@ru.mvista.com>
User-Agent: Thunderbird 1.5 (X11/20060313)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       linuxppc@ozlabs.org, adaplas@gmail.com
Subject: Re: [PATCH 5/6] Xilinxfb: cleanup platform_bus binding to use platform
 bus API.
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net> <20071001155754.6114.6830.stgit@trillian.cg.shawcable.net>
In-Reply-To: <20071001155754.6114.6830.stgit@trillian.cg.shawcable.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> Change the platform bus binding to make use of the established
> platform_bus API.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---

Acked-by: Andrei Konovalov <akonovalov@ru.mvista.com>

>  drivers/video/xilinxfb.c |   32 ++++++++++++++++----------------
>  1 files changed, 16 insertions(+), 16 deletions(-)
