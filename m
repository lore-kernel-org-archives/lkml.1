Return-Path: <linux-kernel-owner+w=401wt.eu-S934152AbYCFDBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbYCFDBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 22:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbYCFDAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 22:00:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51010
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S934601AbYCFDAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 22:00:07 -0500
Date: Wed, 05 Mar 2008 19:00:03 -0800 (PST)
Message-Id: <20080305.190003.22581298.davem@davemloft.net>
To: hannemann@nets.rwth-aachen.de
Cc: ilpo.jarvinen@helsinki.fi, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH-RESEND] Removing unneeded statement from tcp_ipv4.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <47CC872F.9020202@nets.rwth-aachen.de>
References: <47CBFBDA.7000801@nets.rwth-aachen.de>
	<Pine.LNX.4.64.0803031603100.28251@kivilampi-30.cs.helsinki.fi>
	<47CC872F.9020202@nets.rwth-aachen.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Date: Tue, 04 Mar 2008 00:18:07 +0100

> Avoid setting tstamp_ok because this is done two lines later anyway.
> 
> Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>

Patch does not apply, your email client has corrupted the
patch by turning tabs into spaces etc.
