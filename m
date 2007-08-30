Return-Path: <linux-kernel-owner+w=401wt.eu-S1760611AbXH3Kxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611AbXH3Kxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 06:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760191AbXH3Kxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 06:53:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36564 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759997AbXH3Kx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 06:53:29 -0400
Message-ID: <46D6A1A5.2000309@garzik.org>
Date: Thu, 30 Aug 2007 06:53:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: HighPoint Linux Team <linux@highpoint-tech.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com
Subject: Re: [PATCH/RESENT] hptiop: adding new firmware interface and more
 PCI device IDs
References: <200605101704.27491.linux@highpoint-tech.com> <200605161438.09717.linux@highpoint-tech.com> <200708291510.53793.linux@highpoint-tech.com> <200708301635.42481.linux@highpoint-tech.com>
In-Reply-To: <200708301635.42481.linux@highpoint-tech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

HighPoint Linux Team wrote:
> updated patch based on Jeff Garzik's comments.
> 
> - check adapter firmware version and use appropriate interface accordingly
> - add new PCI device IDs and use PCI_VDEVICE macro
> - update driver version string
> - remove unused data structures
> - remove unnecessary typecasts
> 
> Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>

ACK


