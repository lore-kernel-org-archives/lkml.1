Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbZKSVak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbZKSVak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbZKSVaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:30:39 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36033 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbZKSVai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:30:38 -0500
Message-ID: <4B05B903.6080403@pobox.com>
Date: Thu, 19 Nov 2009 16:30:43 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pata_hpt37x: add proper cable detection methods
References: <200911191910.44609.bzolnier@gmail.com>
In-Reply-To: <200911191910.44609.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2009 01:10 PM, Bartlomiej Zolnierkiewicz wrote:
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/pata_hpt37x.c |   86 +++++++++++++++++++++++++++++-----------------
>   1 file changed, 56 insertions(+), 30 deletions(-)

applied 1-2


