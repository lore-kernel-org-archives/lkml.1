Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYHDEFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYHDEFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 00:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbYHDEEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 00:04:54 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:39660 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750809AbYHDEEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 00:04:53 -0400
Date: Mon, 4 Aug 2008 09:34:39 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dwilder@us.ibm.com, hch@infradead.org,
       prasad@linux.vnet.ibm.com
Subject: [Patch 0/2] Renaming 'trace' to 'relay' and enhancements to 'relay'
Message-ID: <20080804040439.GA6415@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
	Please find the patches that enhance the 'trace' infrastructure
(available in the -mm tree) and which introduce two new APIs
relay_dump() and relay_printk().

These patches were submitted earlier as enhancements to trace, but were
renamed and merged with 'relay' based on your suggestion
(http://lkml.org/lkml/2008/5/28/207).

The patches apply on 2.6.27-rc1-mm1 and have been tested on an x86
machine. Kindly accept them.

Thanks,
K.Prasad

