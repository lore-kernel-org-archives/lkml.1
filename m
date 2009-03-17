Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZCQO7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZCQO7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 10:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZCQO7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 10:59:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38559 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752748AbZCQO7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 10:59:10 -0400
Date: Tue, 17 Mar 2009 14:58:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: jkosina@suse.cz, gregkh@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 29-rc-mmotm - HID/USB wedge w/ WARNING: at
 kernel/workqueue.c:371
Message-ID: <20090317145843.07526bca@lxorguk.ukuu.org.uk>
In-Reply-To: <6648.1237271589@turing-police.cc.vt.edu>
References: <6648.1237271589@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> [ 3816.196815] WARNING: at kernel/workqueue.c:371 flush_cpu_workqueue+0x32/0x82()
> [ 3816.196820] Hardware name: Latitude D820                   
> [ 3816.196823] Modules linked in: 
>               ... nvidia(P) 

You really need to reproduce this without the proprietary stuff loaded
