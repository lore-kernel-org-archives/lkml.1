Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbYBOSwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbYBOSwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbYBOSwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:52:01 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54632 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbYBOSwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:52:00 -0500
Message-ID: <47B5DF4E.5040407@garzik.org>
Date: Fri, 15 Feb 2008 13:51:58 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Tejun Heo <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 01/11] ata: fix sparse warning in ata_piix.c
References: <1202966045.2748.15.camel@brick>
In-Reply-To: <1202966045.2748.15.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> drivers/ata/ata_piix.c:1655:8: warning: symbol 'rc' shadows an earlier one
> drivers/ata/ata_piix.c:1616:6: originally declared here
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/ata/ata_piix.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied 1-4


