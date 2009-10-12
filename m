Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbZJLKmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbZJLKmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbZJLKm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:42:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32806
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756057AbZJLKm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:42:28 -0400
Date: Mon, 12 Oct 2009 03:42:24 -0700 (PDT)
Message-Id: <20091012.034224.64980795.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       mcetra@navynet.it
Subject: Re: [Bug #14378] Problems with net/core/skbuff.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <r-4Wjt4coy.A.CwC.Wal0KB@chimera>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
	<r-4Wjt4coy.A.CwC.Wal0KB@chimera>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Mon, 12 Oct 2009 00:22:04 +0200 (CEST)

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14378
> Subject		: Problems with net/core/skbuff.c
> Submitter	: Massimo Cetra <mcetra@navynet.it>
> Date		: 2009-10-08 14:51 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=125501488220358&w=4

I don't know what to do about this one.

The user indicates that they have the vserver patches applied,
so maybe there is some interaction with that stuff.
