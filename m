Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYCKAvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYCKAvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYCKAvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:51:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50851 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYCKAvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:51:32 -0400
Message-ID: <47D5D792.5030402@garzik.org>
Date: Mon, 10 Mar 2008 20:51:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: linux-ide <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 02/16] ata: replace remaining __FUNCTION__ occurrences
References: <1204770292.14154.38.camel@brick>
In-Reply-To: <1204770292.14154.38.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/ata/libata-acpi.c   |    8 ++++----
>  drivers/ata/libata-core.c   |   14 +++++++-------
>  drivers/ata/pata_pdc2027x.c |    2 +-
>  3 files changed, 12 insertions(+), 12 deletions(-)

applied


