Return-Path: <linux-kernel-owner+w=401wt.eu-S1763446AbXGFRoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763446AbXGFRoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760042AbXGFRn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:43:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51381 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759970AbXGFRn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:43:57 -0400
Date: Fri, 6 Jul 2007 18:43:56 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] pata_ali not working on a 64 bit system
Message-ID: <20070706174356.GY21478@ftp.linux.org.uk>
References: <20070706173605.GA6484@dreamland.darkstar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070706173605.GA6484@dreamland.darkstar.lan>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 07:36:05PM +0200, Luca Tettamanti wrote:
> Hello,
> I found out that pata_ali is not working with a 64 bit kernel, while a
> 32 bit kernel on the same machine works fine. I'm running a very recent
> kernel (872aad45, somewhere after 2.6.22-rc7).

Works on alpha...
