Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbXKJFca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbXKJFca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 00:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbXKJFcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 00:32:19 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36656 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbXKJFcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 00:32:18 -0500
Message-ID: <47354258.30501@garzik.org>
Date: Sat, 10 Nov 2007 00:32:08 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Andrew Morton <akpm@linux-foundation.org>, roppedisano@infracomspa.it,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, rjw@sisk.pl,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] Don't fail ata device revalidation for bad _GTF methods
References: <4731C86B.1040704@infracomspa.it> <20071107121355.5eaf4496.akpm@linux-foundation.org> <47333CCF.1050403@infracomspa.it> <20071108094958.5c9b1b22.akpm@linux-foundation.org> <20071108180256.GB3491@havoc.gtf.org> <20071108101341.6c4f88d4.akpm@linux-foundation.org> <20071108182217.GA2685@srcf.ucam.org> <20071108183707.GA3008@srcf.ucam.org>
In-Reply-To: <20071108183707.GA3008@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> Experience suggests that the _GTF method may be bad. We currently fail 
> device revalidation in that case, which seems excessive.
> 
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

applied


