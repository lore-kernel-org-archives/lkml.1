Return-Path: <linux-kernel-owner+w=401wt.eu-S934611AbXFFRyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934611AbXFFRyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbXFFRyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:54:40 -0400
Received: from bay0-omc1-s18.bay0.hotmail.com ([65.54.246.90]:58671 "EHLO
	bay0-omc1-s18.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755973AbXFFRyj (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:54:39 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Wed, 6 Jun 2007 13:54:42 -0400
From: Sean <seanlkml@sympatico.ca>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux-Kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@stusta.de>
Subject: Re: rc4 libata regression - commit 464cf177
Message-Id: <20070606135442.e2c174d1.seanlkml@sympatico.ca>
In-Reply-To: <46667B8A.1090808@gmail.com>
References: <20070606014345.787c6efc.seanlkml@sympatico.ca>
	<46667B8A.1090808@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2007 17:54:48.0021 (UTC) FILETIME=[C5FC1850:01C7A863]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 18:16:58 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Can you describe the problem better?  Is it device misdetection on
> sata_promise or something else?
 
Tejun,

The poorly described booting problem I was seeing here was fixed by
your patch: "sata_promise: use TF interface for polling NODATA commands".

Thanks,
Sean
