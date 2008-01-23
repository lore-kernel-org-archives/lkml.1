Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbYAWDBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbYAWDBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 22:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYAWDBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 22:01:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36590
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbYAWDB3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 22:01:29 -0500
Date: Tue, 22 Jan 2008 19:01:37 -0800 (PST)
Message-Id: <20080122.190137.206066966.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: ilpo.jarvinen@helsinki.fi, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: 2.6.24-rc8-mm1 : net tcp_input.c warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <a8e1da0801221744m37021e88h5c188e5b31ea42bf@mail.gmail.com>
References: <a8e1da0801220109v6bf8931ev50f2210402c3ba41@mail.gmail.com>
	<Pine.LNX.4.64.0801221115150.31652@kivilampi-30.cs.helsinki.fi>
	<a8e1da0801221744m37021e88h5c188e5b31ea42bf@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Young" <hidave.darkstar@gmail.com>
Date: Wed, 23 Jan 2008 09:44:30 +0800

> On Jan 22, 2008 6:47 PM, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:
> > [PATCH] [TCP]: debug S+L
> 
> Thanks, If there's new findings I will let you know.

Thanks for helping with this bug Dave.
