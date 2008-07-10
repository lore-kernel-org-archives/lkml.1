Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYGJLSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYGJLSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 07:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYGJLSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 07:18:42 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:33812 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbYGJLSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 07:18:41 -0400
Date: Thu, 10 Jul 2008 13:17:50 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mmc: Export internal host state through debugfs
Message-ID: <20080710131750.57df4cd8@siona.local>
In-Reply-To: <20080710103348.53344978@mjolnir.drzeus.cx>
References: <1214843703-13199-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214918094-26758-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214918094-26758-2-git-send-email-haavard.skinnemoen@atmel.com>
	<20080704194556.73061a08@mjolnir.drzeus.cx>
	<20080705154436.27830440@siona.local>
	<20080710103348.53344978@mjolnir.drzeus.cx>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jul 2008 11:17:57.0583 (UTC) FILETIME=[9B1795F0:01C8E27E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 10:33:48 +0200
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> > I guess we'll have to throw in a couple of #ifdefs then...
> >   
> 
> Have you managed do have a look at this?

Not really, sorry. I'm currently on vacation, so I can't really do a
lot of testing...but maybe I'll be able to cook up a patch during the
next couple of days.

Haavard
