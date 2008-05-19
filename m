Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYESFJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYESFJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 01:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYESFJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 01:09:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46048
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbYESFJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 01:09:49 -0400
Date: Sun, 18 May 2008 22:09:44 -0700 (PDT)
Message-Id: <20080518.220944.147901584.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lmb: Fix compile warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0805182333550.10619@blarg.am.freescale.net>
References: <1211136296-4572-2-git-send-email-galak@kernel.crashing.org>
	<20080518.203116.199516667.davem@davemloft.net>
	<Pine.LNX.4.64.0805182333550.10619@blarg.am.freescale.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Sun, 18 May 2008 23:34:36 -0500 (CDT)

> lib/lmb.c: In function 'lmb_dump_all':
> lib/lmb.c:51: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'u64'
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

Acked-by: David S. Miller <davem@davemloft.net>
