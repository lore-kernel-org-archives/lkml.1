Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbZDKJpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbZDKJpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 05:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbZDKJor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 05:44:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51752
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756461AbZDKJoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 05:44:46 -0400
Date: Sat, 11 Apr 2009 02:44:36 -0700 (PDT)
Message-Id: <20090411.024436.40931952.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: netdev@vger.kernel.org, jwboyer@linux.vnet.ibm.com,
       galak@kernel.crashing.org, subrata@linux.vnet.ibm.com,
       Linuxppc-dev@ozlabs.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org, greg@kroah.com,
       sachinp@linux.vnet.ibm.com, sfr@canb.auug.org.au
Subject: Re: [BUILD FAILURE 04] Next April 9 : PPC64 randconfig
 [drivers/net/ibm_newemac/core.c]
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090410015614.GA5781@orion>
References: <BE92FB74-1784-414B-B27F-8329185EB3AE@kernel.crashing.org>
	<20090409143112.GA7538@yoda.jdub.homelinux.org>
	<20090410015614.GA5781@orion>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Fri, 10 Apr 2009 05:56:14 +0400

> Subject: [PATCH] ibm_newemac: convert to netdev_ops
> 
> 
> Reported-by: Subrata Modak <subrata@linux.vnet.ibm.com>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Applied.
