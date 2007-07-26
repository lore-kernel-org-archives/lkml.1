Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbXGZA2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbXGZA2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 20:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbXGZA2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 20:28:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54994
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751591AbXGZA2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 20:28:14 -0400
Date: Wed, 25 Jul 2007 17:28:13 -0700 (PDT)
Message-Id: <20070725.172813.03082027.davem@davemloft.net>
To: gallatin@myri.com
Cc: ossthema@de.ibm.com, netdev@vger.kernel.org, raisch@de.ibm.com,
       themann@de.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, meder@de.ibm.com, tklein@de.ibm.com,
       stefan.roscher@de.ibm.com, jeff@garzik.org, johnpol@2ka.mipt.ru
Subject: Re: [RFC 0/1] lro: Generic Large Receive Offload for TCP traffic
From: David Miller <davem@davemloft.net>
In-Reply-To: <46A785C2.9090708@myri.com>
References: <200707201741.45079.ossthema@de.ibm.com>
	<46A785C2.9090708@myri.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Gallatin <gallatin@myri.com>
Date: Wed, 25 Jul 2007 13:17:54 -0400

> I've ported myri10ge to use the new LRO interface.  I have attached a
> preliminary patch to myri10ge.  I'm very pleased to note that the
> performance is on-par with my own LRO used by our out-of-tree driver.
> (except when using mixed MTUS, see performance data below).

Thanks for posting this port and feedback on the generic LRO
code.
