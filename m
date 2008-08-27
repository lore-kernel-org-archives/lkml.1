Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYH0MpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYH0MpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 08:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYH0MpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 08:45:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45597 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbYH0MpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 08:45:04 -0400
Date: Wed, 27 Aug 2008 14:47:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: jassi brar <jassi_singh_brar@yahoo.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: An idea .... with code
Message-ID: <20080827124734.GT26610@one.firstfloor.org>
References: <20080827074751.GO26610@one.firstfloor.org> <35042.98883.qm@web33207.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35042.98883.qm@web33207.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  As far as features are concerned, please suggest me what could be done with /dev/loop0 and not for /dev/vblk?

Serious question?  cryptoloop, offsets are the big ticket items,
i'm sure there are more.

-Andi
