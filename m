Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbXEAXQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbXEAXQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXEAXQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:16:17 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:53561 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbXEAXQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:16:16 -0400
Date: Tue, 1 May 2007 16:16:15 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Markus Rechberger <mrechberger@gmail.com>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] Re: DST/BT878 module customization (.. was: Critical
 points about ...)
In-Reply-To: <1178031333.3958.63.camel@localhost>
Message-ID: <Pine.LNX.4.58.0705011606070.309@shell2.speakeasy.net>
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
 <1178031333.3958.63.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Mauro Carvalho Chehab wrote:
> With this configuration, dvb-bt8xx hangs during initialization,
> generating an OOPS, if you have a board with DST (modprobe dvb-bt8xx
> never returns).

Stupid typo in the first patch, a != should have been ==.

Fixed:
http://linuxtv.org/hg/~tap/dst-new
