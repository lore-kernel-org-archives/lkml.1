Return-Path: <linux-kernel-owner+w=401wt.eu-S1760123AbZFJPgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123AbZFJPgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbZFJPgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:36:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60211 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756084AbZFJPga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:36:30 -0400
Date: Wed, 10 Jun 2009 16:37:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: tom.leiming@gmail.com, greg@kroah.com, linux-kernel@vger.kernel.org,
       kay.sievers@vrfy.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] init/do_mounts.c: replace polling for root device
 with devtmpfs_wait_for_dev
Message-ID: <20090610163712.3b5297d7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090610152811.GA21888@infradead.org>
References: <1244644097-305-1-git-send-email-tom.leiming@gmail.com>
	<20090610152811.GA21888@infradead.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What tree did you find with devtmpfs in it?  It was pretty clearly
> rejected when it came up.

For some reason its still in -next
