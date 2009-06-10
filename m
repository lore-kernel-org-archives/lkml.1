Return-Path: <linux-kernel-owner+w=401wt.eu-S1759721AbZFJKCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721AbZFJKCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 06:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbZFJKB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 06:01:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35132 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754392AbZFJKBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 06:01:55 -0400
Date: Wed, 10 Jun 2009 11:02:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: oliver@hartkopp.net, hawk@comx.dk, paulmck@linux.vnet.ibm.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       urs.thuermann@volkswagen.de, oliver.hartkopp@volkswagen.de,
       wg@grandegger.com, vladislav.yasevich@hp.com, sri@us.ibm.com,
       linux-sctp@vger.kernel.org, Trond.Myklebust@netapp.com,
       linux-nfs@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 3/5] can: af_can.c use rcu_barrier() on module unload.
Message-ID: <20090610110250.17644ae4@lxorguk.ukuu.org.uk>
In-Reply-To: <20090610.011027.43904351.davem@davemloft.net>
References: <20090608130959.10052.54590.stgit@localhost>
	<20090608131138.10052.5408.stgit@localhost>
	<4A2D112A.4000308@hartkopp.net>
	<20090610.011027.43904351.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009 01:10:27 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Oliver Hartkopp <oliver@hartkopp.net>
> Date: Mon, 08 Jun 2009 15:24:58 +0200
> 
> > Acked-By: Oliver Hartkopp <oliver@hartkopp.net>
> 
> Please don't capitalize the "By" in "Acked-By".  Otherwise
> patchwork doesn't pick them up automatically.

Dave. We have computers to do all the silly tedious pointless jobs in
life, please just fix the scripts.

Alan
