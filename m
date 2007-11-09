Return-Path: <linux-kernel-owner+w=401wt.eu-S1761932AbXKICbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761932AbXKICbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 21:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758820AbXKICbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 21:31:31 -0500
Received: from havoc.gtf.org ([69.61.125.42]:60872 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758638AbXKICbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 21:31:31 -0500
Date: Thu, 8 Nov 2007 21:31:30 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Riki Oktarianto <rkoktarianto@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071109023129.GA25581@havoc.gtf.org>
References: <20071109020235.GA2031@ceren>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071109020235.GA2031@ceren>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 09:02:35AM +0700, Riki Oktarianto wrote:
> Some BIOSen map AHCI ABAR but lock the SATA controller to IDE mode.
> This patch add quirk to set AHCI mode on ICH board with such case.
> 
> Tested on Macbook2,1 (ICH7M)

Intel will complain but it's awful tempting...

	Jeff



