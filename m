Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZGFVg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZGFVg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZGFVgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:36:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49647
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbZGFVgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:36:00 -0400
Date: Mon, 06 Jul 2009 14:36:06 -0700 (PDT)
Message-Id: <20090706.143606.09407511.davem@davemloft.net>
To: gurligebis@gmail.com
Cc: Larry.Finger@lwfinger.net, chunkeey@web.de, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p54: Fix regression in 2.6.31-rcX since commit a1091aa
 - sleeping function called from invalid context
From: David Miller <davem@davemloft.net>
In-Reply-To: <9c30dffe0907061326n77823e03lf87f4feb616c8f7b@mail.gmail.com>
References: <4A5253F1.50504@lwfinger.net>
	<20090706.125011.56653570.davem@davemloft.net>
	<9c30dffe0907061326n77823e03lf87f4feb616c8f7b@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjarke Istrup Pedersen <gurligebis@gmail.com>
Date: Mon, 6 Jul 2009 22:26:09 +0200

> I can confirm that the patch fixes the problem with my PCMCIA card :-)

Thanks for testing :)
