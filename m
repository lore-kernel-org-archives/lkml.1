Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbYGWUqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbYGWUqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYGWUqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:46:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52595 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbYGWUqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:46:45 -0400
Message-ID: <488798B0.4080205@garzik.org>
Date: Wed, 23 Jul 2008 16:46:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Wedgwood <cw@f00f.org>
Subject: Re: [PATCH 1/7] ata: add missing ATA_CMD_* defines
References: <200807232040.18264.bzolnier@gmail.com>
In-Reply-To: <200807232040.18264.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Add missing ATA_CMD_* defines to <linux/ata.h>.  Also add
> ATA_EXABYTE_ENABLE_NEST, SETFEATURES_AAM_* and ATA_SMART_*
> defines while at it.
> 
> Partially based on earlier work by Chris Wedgwood.
> 
> Cc: Chris Wedgwood <cw@f00f.org>
> Cc: Jeff Garzik <jeff@garzik.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  include/linux/ata.h |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

ACK patches 1-2, feel free to send upstream alongside patches 3-7


