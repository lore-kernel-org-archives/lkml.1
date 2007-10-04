Return-Path: <linux-kernel-owner+w=401wt.eu-S1760422AbXJDMBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760422AbXJDMBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 08:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXJDMBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 08:01:10 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:42283 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1752443AbXJDMBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 08:01:09 -0400
Message-ID: <4704D71E.8080607@ru.mvista.com>
Date: Thu, 04 Oct 2007 16:05:50 +0400
From: Andrei Konovalov <akonovalov@ru.mvista.com>
User-Agent: Thunderbird 1.5 (X11/20060313)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       linuxppc@ozlabs.org, adaplas@gmail.com
Subject: Re: [PATCH 1/6] Xilinxfb: add banner output to probe routine when
 DEBUG	is defined
References: <20071001155024.6114.47993.stgit@trillian.cg.shawcable.net> <20071001155733.6114.71740.stgit@trillian.cg.shawcable.net>
In-Reply-To: <20071001155733.6114.71740.stgit@trillian.cg.shawcable.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> Debug support: when DEBUG is defined, output relevant details to the
> log about the framebuffer registration.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---

Acked-by: Andrei Konovalov <akonovalov@ru.mvista.com>

>  drivers/video/xilinxfb.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
