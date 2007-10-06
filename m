Return-Path: <linux-kernel-owner+w=401wt.eu-S1765389AbXJFUMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765389AbXJFUMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 16:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761393AbXJFUM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 16:12:27 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59044 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbXJFUM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 16:12:26 -0400
Date: Sat, 6 Oct 2007 22:12:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 2/2] getattr - fill the size of FIFOs
In-Reply-To: <E1Id01C-0000hm-3Z@be1.lrz>
Message-ID: <Pine.LNX.4.64.0710062212160.20637@fbirervta.pbzchgretzou.qr>
References: <99UcC-5uM-51@gated-at.bofh.it> <99UcC-5uM-49@gated-at.bofh.it>
 <E1Id01C-0000hm-3Z@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 3 2007 10:55, Bodo Eggert wrote:
>
>> [PATCH]: Fill the size of FIFOs
>> 
>> Instead of reporting 0 in size when stating() a pipe
>
>FIFO

Yes
