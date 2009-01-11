Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbZAKHhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbZAKHhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 02:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZAKHhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 02:37:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59598
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbZAKHhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 02:37:00 -0500
Date: Sat, 10 Jan 2009 23:36:59 -0800 (PST)
Message-Id: <20090110.233659.144845240.davem@davemloft.net>
To: gorcunov@gmail.com
Cc: jchapman@katalix.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       devel@openvz.org, xemul@openvz.org
Subject: Re: [RFC 3/4] net: pppol2tp - introduce net-namespace functionality
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090110125444.GB29349@localhost>
References: <49688120.9000507@katalix.com>
	<20090110111359.GA29349@localhost>
	<20090110125444.GB29349@localhost>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Sat, 10 Jan 2009 15:54:44 +0300

> Maybe you have some other commits which are not propogated
> to net-next-2.6 yet?

net-next-2.6 is a throw away tree that is a clone of essentially
2.6.28 after Linus first took the net-next-2.6

It has not been updated for weeks, all development has been
occurring in the net-2.6 tree
