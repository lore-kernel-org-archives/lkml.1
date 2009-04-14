Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbZDNWSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbZDNWSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZDNWS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:18:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55985
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbZDNWS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:18:28 -0400
Date: Tue, 14 Apr 2009 15:18:19 -0700 (PDT)
Message-Id: <20090414.151819.88596256.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: netdev@vger.kernel.org, subrata@linux.vnet.ibm.com,
       Linuxppc-dev@ozlabs.org, greg@kroah.com, raisch@de.ibm.com,
       themann@de.ibm.com, tklein@de.ibm.com, julia@diku.dk, jgarzik@pobox.com,
       mel@skynet.ie, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       sachinp@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       linux-net@vger.kernel.org
Subject: Re: [BUILD FAILURE 06/12] Next April 14 : PPC64 randconfig
 [drivers/net/ehea/ehea_main.c]
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090414183938.GA17134@orion>
References: <1239733747.5344.78.camel@subratamodak.linux.ibm.com>
	<20090414183938.GA17134@orion>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Tue, 14 Apr 2009 22:39:38 +0400

> ehea: Fix incomplete conversion to net_device_ops
> 
> Reported-by: Subrata Modak <subrata@linux.vnet.ibm.com>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Applied, thanks Alexander.
