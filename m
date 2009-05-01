Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbZEALBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbZEALBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZEALB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:01:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41509 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbZEALB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:01:26 -0400
Date: Fri, 1 May 2009 12:01:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
 tmpfs
Message-ID: <20090501120131.642b1cae@lxorguk.ukuu.org.uk>
In-Reply-To: <20090501061701.GB19234@kroah.com>
References: <1241097822.2516.3.camel@poy>
	<20090430222900.c13b63d5.akpm@linux-foundation.org>
	<20090501061701.GB19234@kroah.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> These are the ones that create a subdirectory in /dev/   None of the
> others do.

Yes they do - sound for example does.

