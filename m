Return-Path: <linux-kernel-owner+w=401wt.eu-S1759769AbYATHXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759769AbYATHXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 02:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYATHXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 02:23:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:41207 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753039AbYATHXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 02:23:15 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18WIxA99PAWO6Q34KZ4LobX8T4zYSX0WtGpNyAOcb
	QDkDaib+F5IGmV
Subject: Re: konqueror deadlocks on 2.6.22
From: Mike Galbraith <efault@gmx.de>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200801200831.04964.a1426z@gawab.com>
References: <200801192114.41427.a1426z@gawab.com>
	 <1200802290.4166.2.camel@homer.simson.net>
	 <200801200831.04964.a1426z@gawab.com>
Content-Type: text/plain
Date: Sun, 20 Jan 2008 08:23:12 +0100
Message-Id: <1200813792.5236.8.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-20 at 08:41 +0300, Al Boldi wrote:

> BTW Mike: Your server bounces my messages.

Hm.  I don't have a server.  Might have something to do with some
naughty task frequently scribbling zeros to /etc/resolv.conf when I
brutally reboot my box (i give myself cause to do that quite a lot).
Fixed for the thousandth time.  Some day I'll track/shoot the bugger.

	-Mike

