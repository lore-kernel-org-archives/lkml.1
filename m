Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbYGaKL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbYGaKL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbYGaKLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:11:48 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53443 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYGaKLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:11:48 -0400
Date: Thu, 31 Jul 2008 12:12:18 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: linuxppc-dev@ozlabs.org
Cc: tinytim@us.ibm.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       jean-pierre.dion@bull.net, paulus@samba.org, gilles.carry@ext.bull.net,
       tglx@linutronix.de
Subject: Re: [PATCH 0/3] powerpc - Make the irq reverse mapping tree
 lockless
Message-ID: <20080731121218.5a07596a@bull.net>
In-Reply-To: <1217497241-10685-1-git-send-email-sebastien.dugue@bull.net>
References: <1217497241-10685-1-git-send-email-sebastien.dugue@bull.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  OK, I goofed up with git-format-patch, forgot the --numbered option.

  The patches subjects should read:

	[PATCH 1/3] powerpc - Initialize the irq radix tree earlier
	[PATCH 2/3] powerpc - Separate the irq radix tree insertion and lookup
	[PATCH 3/3] powerpc - Make the irq reverse mapping radix tree lockless

  Sorry for that.

  Sebastien.
