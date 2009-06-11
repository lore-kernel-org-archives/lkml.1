Return-Path: <linux-kernel-owner+w=401wt.eu-S1762757AbZFKLkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762757AbZFKLkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZFKLj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:39:59 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:64077 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbZFKLj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:39:59 -0400
Date: Thu, 11 Jun 2009 12:40:00 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: mmc_spi-use-eilseq-for-possible-transmission-errors.patch (was Re:
	2.6.31 -mm merge plans)
Message-ID: <20090611114000.GA5435@console-pimps.org>
References: <20090610115140.09c9f4cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610115140.09c9f4cb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 11:51:40AM -0700, Andrew Morton wrote:
> 
> mmc_spi-use-eilseq-for-possible-transmission-errors.patch
> 
>  -> mmc
> 

I think this patch can be dropped from your series as Wolfgang
proposed a newer, improved version here,
http://lkml.org/lkml/2009/6/10/63.  I'm guessing his new patch is
going to be taken through Pierre's tree?
