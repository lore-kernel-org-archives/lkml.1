Return-Path: <linux-kernel-owner+w=401wt.eu-S1759681AbXFUTyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681AbXFUTyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbXFUTyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:54:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40101 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758204AbXFUTyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:54:18 -0400
Date: Thu, 21 Jun 2007 20:54:16 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Fengwei Yin <yfw.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Type error in drivers/input/tsdev.c?
In-Reply-To: <4677A1C0.7020103@gmail.com>
Message-ID: <Pine.LNX.4.64.0706212052570.32460@pentafluge.infradead.org>
References: <ab18d8520706190211v1a5b4a17u57d0927400e15a5e@mail.gmail.com>
 <4677A1C0.7020103@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Fengwei Yin napsal(a):
> > Hi,
> > In function tsdev_event() of drivers/input/tsdev.c,
> > conversion from usec to milisec is like:
> >    client->event[client->head].millisecs =
> >         time.tv_usec / 100;
> >                  ~~~~~~ should be 1000?
> 
> Seems so. James CCed.

Thats my old email address. Tsdev is schedule for deletion.

