Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbXJYGBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbXJYGBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 02:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbXJYGBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 02:01:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55686 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbXJYGBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 02:01:44 -0400
Message-ID: <47203147.7050408@garzik.org>
Date: Thu, 25 Oct 2007 02:01:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] libata-core.c: make 2 functions static
References: <20071024162306.GF30533@stusta.de>
In-Reply-To: <20071024162306.GF30533@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> strn_pattern_cmp() and ata_port_detach() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/ata/libata-core.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

applied


