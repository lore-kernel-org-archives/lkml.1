Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYDWKuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYDWKuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYDWKue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 06:50:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37968
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752108AbYDWKud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 06:50:33 -0400
Date: Wed, 23 Apr 2008 03:50:35 -0700 (PDT)
Message-Id: <20080423.035035.267136505.davem@davemloft.net>
To: bunk@kernel.org
Cc: davem@sunset.davemloft.net, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] unexport proc_clear_tty
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080423095210.GF28933@cs181133002.pp.htv.fi>
References: <20080423095210.GF28933@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Wed, 23 Apr 2008 12:52:10 +0300

> With the removal of the Solaris binary emulation the export of 
> proc_clear_tty became unused.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
