Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbYL2Ml2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbYL2Ml2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYL2MlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:41:20 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:37322 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbYL2MlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:41:19 -0500
Message-ID: <4958C56A.1090805@garzik.org>
Date: Mon, 29 Dec 2008 07:41:14 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       Alexandru Romanescu <a_romanescu@yahoo.co.uk>,
       Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] DMI: add dmi_match
References: <493EE339.1070806@garzik.org> <1228914442-30805-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1228914442-30805-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Add a wrapper for testing system_info which will handle also NULL
> system infos.
> 
> This will be used by the ata PIIX driver.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jeff Garzik <jgarzik@redhat.com>
> Cc: Alexandru Romanescu <a_romanescu@yahoo.co.uk>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
>  drivers/firmware/dmi_scan.c |   16 ++++++++++++++++
>  include/linux/dmi.h         |    3 +++
>  2 files changed, 19 insertions(+), 0 deletions(-)

applied 1-2


