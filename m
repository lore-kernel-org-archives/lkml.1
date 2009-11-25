Return-Path: <linux-kernel-owner+w=401wt.eu-S935149AbZKYXTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935149AbZKYXTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 18:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935062AbZKYXTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 18:19:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49498
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934886AbZKYXTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 18:19:07 -0500
Date: Wed, 25 Nov 2009 15:19:25 -0800 (PST)
Message-Id: <20091125.151925.92362266.davem@davemloft.net>
To: bharrosh@panasas.com
Cc: bfields@citi.umich.edu, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org,
       linux-s390@vger.kernel.org, linux-nfs@vger.kernel.org,
       pnfs@linux-nfs.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2/5] sparc: remove unused nfsd #includes
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B0C1F5C.9090903@panasas.com>
References: <4B0C1EB7.50508@panasas.com>
	<4B0C1F5C.9090903@panasas.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boaz Harrosh <bharrosh@panasas.com>
Date: Tue, 24 Nov 2009 20:01:00 +0200

> 
> Some unused includes removed.
> 
> In an effort to cleanup nfsd headers and move private
> definitions to source directory.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Applied to sparc-next-2.6, thank you.
