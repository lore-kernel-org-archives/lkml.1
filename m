Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZCXBI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZCXBI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 21:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZCXBIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 21:08:16 -0400
Received: from mail.vyatta.com ([76.74.103.46]:49725 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbZCXBIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 21:08:16 -0400
Date: Mon, 23 Mar 2009 18:08:08 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: phillip@lougher.demon.co.uk
Cc: linux-kernel@vger.kernel.org, squashfs-devel@lists.sourceforge.net
Subject: Squashfs 4.0 tools
Message-ID: <20090323180808.2c2ef1a7@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is great that squashfs is finally in mainline kernel. But the
squashfs tools are tightly bound to the version of the squashfs filesystem.
The latest tools in Debian (and the download page) are limited to 
version 3.4 but the upstream kernel version is 4.0!

Do we have a cart with no horse here?
