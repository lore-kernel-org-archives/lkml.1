Return-Path: <linux-kernel-owner+w=401wt.eu-S1761463AbZCaWBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463AbZCaWBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbZCaWBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:01:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35291
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbZCaWBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:01:00 -0400
Date: Tue, 31 Mar 2009 15:00:49 -0700 (PDT)
Message-Id: <20090331.150049.117005736.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] kaweth: Fix locking to be SMP-safe
From: David Miller <davem@davemloft.net>
In-Reply-To: <49d00512.XAF19LdpY1dlK6+U%Larry.Finger@lwfinger.net>
References: <49d00512.XAF19LdpY1dlK6+U%Larry.Finger@lwfinger.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 29 Mar 2009 18:32:34 -0500

> Jeff,
> 
> As the listed authors of this driver have not touched it in several years,
> I have taken the liberty of sending it to you as networking drivers maintainer.
> I hope this is OK.

I've been handling networking driver patches for a few months
now, so you only need CC: me.

Thanks.
