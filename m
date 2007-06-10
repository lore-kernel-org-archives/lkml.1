Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbXFJCmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbXFJCmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 22:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145AbXFJCmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 22:42:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35861 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976AbXFJCmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 22:42:32 -0400
Message-ID: <466B64F0.2030702@garzik.org>
Date: Sat, 09 Jun 2007 22:41:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Florin Iucha <florin@iucha.net>, Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@kernel.vger.org
Subject: Re: [PATCH] libata: disable NCQ for HITACHI HTS541680J9SA00/SB21C7EP
References: <fa.Nigm+GFAuAW+QzfgqTUfmHJoFfU@ifi.uio.no> <4666C477.1070603@shaw.ca> <20070607120430.GB30661@iucha.net> <466951DE.9070004@gmail.com> <20070608131157.GH30661@iucha.net> <20070608132059.GG29122@htj.dyndns.org>
In-Reply-To: <20070608132059.GG29122@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> HITACHI HTS541680J9SA00/SB21C7EP spuriously completes NCQ commands.
> Blacklist it for NCQ.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  drivers/ata/libata-core.c |    2 ++
>  1 file changed, 2 insertions(+)

applied


