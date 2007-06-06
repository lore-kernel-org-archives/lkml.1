Return-Path: <linux-kernel-owner+w=401wt.eu-S934559AbXFFPnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559AbXFFPnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760857AbXFFPnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:43:11 -0400
Received: from main.gmane.org ([80.91.229.2]:42166 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758901AbXFFPnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:43:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <wa1ter@myrealbox.com>
Subject: Re: [REPOST PATCH] sata_promise: use TF interface for polling NODATA
 commands
Date: Wed, 06 Jun 2007 08:42:50 -0700
Organization: none
Message-ID: <f46klr$noo$1@sea.gmane.org>
References: <200706052131.l55LVkYN000191@harpo.it.uu.se> <20070605215256.GT31565@havoc.gtf.org> <46665AB5.6040508@gmail.com> <20070606102122.GD29122@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-204-207.dsl.irvnca.pacbell.net
User-Agent: Thunderbird 3.0a1pre (X11/20070606)
In-Reply-To: <20070606102122.GD29122@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> ...  Fix pdc_qc_issue_prot() such that ATA/ATAPI NODATA
> commands are issued using TF interface if ATA_TFLAG_POLLING is set.
> 
> This patch fixes detection failure introduced by polling SETXFERMODE.

Your patch works for me, thanks.


