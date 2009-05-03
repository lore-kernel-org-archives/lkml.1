Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZECVUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZECVUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 17:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZECVUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 17:20:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53724
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753651AbZECVUe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 17:20:34 -0400
Date: Sun, 03 May 2009 14:20:29 -0700 (PDT)
Message-Id: <20090503.142029.245176169.davem@davemloft.net>
To: rbrito@ime.usp.br
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH] powerpc: convert mace to netdev_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090503.141524.253766195.davem@davemloft.net>
References: <20090427.054258.16622932.davem@davemloft.net>
	<20090503114820.GA14926@ime.usp.br>
	<20090503.141524.253766195.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 03 May 2009 14:15:24 -0700 (PDT)

> From: Rogério Brito <rbrito@ime.usp.br>
> Date: Sun, 3 May 2009 08:48:20 -0300
> 
>> I hope that this version is a slightly better fix to convert mace to
>> netdev_ops.
>> 
>> This is against this morning's net-2.6 tree.
>> 
>> Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
> 
> I'll apply this, thanks!  I made one change however.

Oh, nevermind, it seems that MACE was already converted
to netdev_ops some time ago in the net-next-2.6 tree.
