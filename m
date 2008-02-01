Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbYBAOqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbYBAOqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 09:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYBAOqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 09:46:45 -0500
Received: from postfix1-g20.free.fr ([212.27.60.42]:58756 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbYBAOqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 09:46:45 -0500
Message-ID: <1201877107.47a3307340b38@imp.free.fr>
Date: Fri, 01 Feb 2008 15:45:07 +0100
From: Gilles Espinasse <g.esp@free.fr>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: RE: [PATCH] USB: mark USB drivers as being GPL only 
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 192.54.193.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>FYI, this is a patch that will be sent out in the next round to Linus
>for inclusion in 2.6.25.
>
>If anyone has any objections about it, please let me know.
>
..
> There are no known closed source USB drivers in the wild, so this
> patch should cause no problems.

There is the unicorn usb adsl modem driver (STM unicorn chip).
http://www.bewan.com/bewan/drivers/A1012-A1006-A904-A888-A983-0.9.3.tgz
There is some sources and a binary blob to be linked.

The only things I know from the binary blob is that sources should be 150 000
lines of C++.

Driver compile with gcc-3 but not with gcc-4 (because of the binary blob).

Gilles
