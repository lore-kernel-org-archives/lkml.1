Return-Path: <linux-kernel-owner+w=401wt.eu-S967913AbXEHFRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967913AbXEHFRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967903AbXEHFR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:17:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54334 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967901AbXEHFRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:17:25 -0400
Message-ID: <464007DF.5030102@garzik.org>
Date: Tue, 08 May 2007 01:17:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Tim Hockin <thockin@hockin.org>,
       =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] natsemi: Improve diagnostics for DspCfg workaround
References: <20070503093435.7800.38591.stgit@mercator.sirena.org.uk> <20070503093650.7800.45441.stgit@mercator.sirena.org.uk>
In-Reply-To: <20070503093650.7800.45441.stgit@mercator.sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> The natsemi driver has a workaround for broken hardware which resets itself
> from time to time.  There is a diagnostic message for this workaround but
> it is not printed by default, making the driver behavior more obscure than
> it needs to be.  Make the message be displayed by default.
> 
> Signed-Off-By: Mark Brown <broonie@sirena.org.uk>
> ---
> 
>  drivers/net/natsemi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied 1-2


