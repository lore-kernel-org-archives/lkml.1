Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbZGNCMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbZGNCMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 22:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZGNCMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 22:12:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41352
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbZGNCMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 22:12:03 -0400
Date: Mon, 13 Jul 2009 19:12:07 -0700 (PDT)
Message-Id: <20090713.191207.212695734.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] NET: sungem, use spin_trylock_irqsave
From: David Miller <davem@davemloft.net>
In-Reply-To: <1247520220-31960-2-git-send-email-jirislaby@gmail.com>
References: <1247520220-31960-1-git-send-email-jirislaby@gmail.com>
	<1247520220-31960-2-git-send-email-jirislaby@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please DO NOT combine cleanups with real bug fixes into
a patch series.

Bug fixes go to one tree, the rest go to another tree, and that is
especially the case this late in the RC series.

A series of patches are a group of changes that are supposed to be
related and are expected to be applied all to the same tree.  That is
not true of the patches you have posted here.
