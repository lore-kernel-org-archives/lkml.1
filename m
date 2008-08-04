Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbYHDShm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbYHDShm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbYHDShG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:37:06 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:33126 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753287AbYHDShC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:37:02 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: lirc drivers out of tree forever?
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 04 Aug 2008 20:36:53 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080804183653.235052C400A@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.76
X-Scan-Result: No virus found in message 1KQ4vT-0007xu-6W.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KQ4vT-0007xu-6W afdd9382a062218e3e47d812fe8f4d62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Being a lirc user and trying to follow kernel stable releases, I asked the 
lirc folks about their plans for eventual intrgration of the kernel releated 
parts into the kernel tree.

http://www.nabble.com/kernel-integration-plans--td17171980.html

The tail end of that thread suggests that there is an active drive to push 
drivers _out_ of the kernel. Is that really the case, and is it the desired 
way forward?

IMHO, anything that calls itself a driver for a piece of hw should be in the
kernel.

/Anders



