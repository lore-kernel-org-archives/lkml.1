Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZFYNxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZFYNxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZFYNxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:53:10 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:43204 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZFYNxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:53:09 -0400
From: Jens Osterkamp <jens@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 12/19] drivers/net: Use PCI_VDEVICE
Date: Thu, 25 Jun 2009 15:52:55 +0200
User-Agent: KMail/1.10.4 (Linux/2.6.27-14-generic; KDE/4.1.4; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       Steffen Klassert <klassert@mathematik.tu-chemnitz.de>,
       Michael Chan <mchan@broadcom.com>,
       Eilon Greenstein <eilong@broadcom.com>, Divy Le Ray <divy@chelsio.com>,
       Samuel Ortiz <samuel@sortiz.org>, Tim Hockin <thockin@hockin.org>,
       Daniele Venzano <venza@brownhat.org>, Jens Osterkamp <jens@de.ibm.com>,
       Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
       Ion Badulescu <ionut@cs.columbia.edu>,
       Andy Gospodarek <andy@greyhouse.net>,
       Alexander Indenbaum <baum@tehutinetworks.net>,
       Samuel Chessman <chessman@tux.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Grant Grundler <grundler@parisc-linux.org>,
       David Dillow <dave@thedillows.org>, netdev@vger.kernel.org
References: <cover.1245906151.git.joe@perches.com>  <f746d5c571120f930fb6bb50d8303766573f927d.1245906152.git.joe@perches.com>
In-Reply-To: <f746d5c571120f930fb6bb50d8303766573f927d.1245906152.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906251552.56458.jens@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 June 2009, Joe Perches wrote:

> drivers/net/spider_net.c          |    3 +-

spider_net bits look fine.

Acked-by: Jens Osterkamp <jens@linux.vnet.ibm.com>

Thanks,

Jens
