Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbXJYGGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbXJYGGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 02:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbXJYGFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 02:05:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51519 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189AbXJYGFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 02:05:41 -0400
Message-ID: <4720322F.5070508@garzik.org>
Date: Thu, 25 Oct 2007 02:05:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: [git patches] IDE updates (part 2)
References: <200710131825.24768.bzolnier@gmail.com> <20071014001238.GP8181@ftp.linux.org.uk>
In-Reply-To: <20071014001238.GP8181@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Proposed addition to icside part, provided that ARM folks ACK it - gets
> icside to build and AFAICS it's correct:
> 
> diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
> index be30923..842fe08 100644
> --- a/drivers/ata/pata_icside.c
> +++ b/drivers/ata/pata_icside.c
> @@ -332,12 +332,13 @@ static void ata_dummy_noret(struct ata_port *port)

applied


