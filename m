Return-Path: <linux-kernel-owner+w=401wt.eu-S1760996AbZCXUYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996AbZCXUYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761142AbZCXUYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:24:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53297
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758806AbZCXUYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:24:07 -0400
Date: Tue, 24 Mar 2009 13:23:55 -0700 (PDT)
Message-Id: <20090324.132355.234010341.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: roel.kluin@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: next-20090318: sunhme does not transmit packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <a4423d670903240850w223cdb74k7165ffd70cd7b357@mail.gmail.com>
References: <a4423d670903240432m1a4e8e08x9c97a0947d89800a@mail.gmail.com>
	<a4423d670903240846j252a825cy1e8a50b5ac3a11ef@mail.gmail.com>
	<a4423d670903240850w223cdb74k7165ffd70cd7b357@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Tue, 24 Mar 2009 18:50:55 +0300

> 2009/3/24 Alexander Beregalov <a.beregalov@gmail.com>:
> > e4a389a9b5c892446b5de2038bdc0cca8703c615 is first bad commit
> 
> No, it is wrong, sorry.
> I will do more tests tomorrow.

I bet it is the problem we are discussing here:

	http://marc.info/?l=linux-kernel&m=123789980524715&w=2

Herbert has posted two patches to try and fix this issue,
you can try the second one to see if it solves your bug
too.
