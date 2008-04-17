Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbYDQBfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbYDQBfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934017AbYDQB3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:29:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52252
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S934013AbYDQB3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:29:42 -0400
Date: Wed, 16 Apr 2008 18:29:38 -0700 (PDT)
Message-Id: <20080416.182938.23275180.davem@davemloft.net>
To: ivdoorn@gmail.com
Cc: linville@tuxdriver.com, hmh@hmh.eng.br, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] rfkill support for r/w and r/o rfkill switches
From: David Miller <davem@davemloft.net>
In-Reply-To: <200804162240.38704.IvDoorn@gmail.com>
References: <200804162126.43771.IvDoorn@gmail.com>
	<20080416195822.GA25066@tuxdriver.com>
	<200804162240.38704.IvDoorn@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivo van Doorn <ivdoorn@gmail.com>
Date: Wed, 16 Apr 2008 22:40:38 +0200

> Dave, do you want the rfkill patches directly, or should they go through
> the wireless tree first?

I'm happy if it goes through the wireless tree.

That way experts like John and the others can review it
from a wireless perspective, and it's one less pull
for me to do :-)
