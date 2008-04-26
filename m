Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbYDZGMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbYDZGMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 02:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYDZGMC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 02:12:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbYDZGMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 02:12:01 -0400
Date: Fri, 25 Apr 2008 23:11:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: speedy <speedy@3d-io.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [BUG REPORT, 2.6.22] sata controler failure on nforce 2 chipset
Message-Id: <20080425231108.03dfa7cb.akpm@linux-foundation.org>
In-Reply-To: <396712385.20080423011459@3d-io.com>
References: <396712385.20080423011459@3d-io.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 23 Apr 2008 01:14:59 +0200 speedy <speedy@3d-io.com> wrote:
> Hello Linux kernel crew,
> 
>        [Consider this more as a datapoint then a bug report, as after
>        one network and one sata/southbridge issues showing up
>        interminnently, the ASRock motherboard involved will be
>        scrapped for a different one]
> 
>        The integrated NVidia sata controller and/or the hard-drive has failed
>        during operation with the following output:

2.6.22 is rather old.  Can you please retest 2.6.25?

Thanks.
