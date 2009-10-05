Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbZJEATa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbZJEATa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757368AbZJEAT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:19:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36696
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757082AbZJEAT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:19:28 -0400
Date: Sun, 04 Oct 2009 17:19:23 -0700 (PDT)
Message-Id: <20091004.171923.211397115.davem@davemloft.net>
To: manty@manty.net
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: kernel BUG at drivers/ide/ide-disk.c:187 (2.6.31)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091004223705.GB5030@dis.manty.net>
References: <20091001.115310.100974682.davem@davemloft.net>
	<20091003033942.GA8129@dis.manty.net>
	<20091004223705.GB5030@dis.manty.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santiago Garcia Mantinan <manty@manty.net>
Date: Mon, 5 Oct 2009 00:37:05 +0200

>> Applied it to 2.6.31.1, I'll wait and see what the weekend tells us.
> 
> up 2 days,  8:27 and still nothing, maybe I shouldn't have applied it to .1
> as some of the fixes there could be masking the problem and I should be
> testing it on 2.6.31 :-?

If 2.6.31.1 fixes your bug, that would be good news :-)
