Return-Path: <linux-kernel-owner+w=401wt.eu-S1163484AbXD1S3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163484AbXD1S3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163485AbXD1S3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:29:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57886 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163484AbXD1S3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:29:31 -0400
Date: Sat, 28 Apr 2007 20:29:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: lkml777@123mail.org
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, linux-kernel@vger.kernel.org,
       Eric Hopper <hopper@omnifarious.org>,
       William Heimbigner <icxcnika@mar.tar.cc>,
       Alex Zarochentsev <zam@namesys.com>, Andi Kleen <andi@firstfloor.org>,
       Rik van Riel <riel@redhat.com>, Edward Shishkin <edward@namesys.com>
Subject: Re: Question about Reiser4 (how to boot it?)
Message-ID: <20070428182928.GA8436@one.firstfloor.org>
References: <462E17AF.7090604@namesys.com> <20070424193921.GA17129@one.firstfloor.org> <462F6717.70508@namesys.com> <b6a2187b0704250749s2a00dadep93b2943bc0b9df9d@mail.gmail.com> <1177564182.15467.1186637743@webmail.messagingengine.com> <b6a2187b0704252348t1242560dqad6a1d30e665abc5@mail.gmail.com> <b6a2187b0704260118x7cf8ed57mab9a12d06a2471a9@mail.gmail.com> <1177658163.8094.1186854037@webmail.messagingengine.com> <b6a2187b0704270937g18f305cdxfdd54349fb73f3ea@mail.gmail.com> <1177717116.1762.1186993177@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177717116.1762.1186993177@webmail.messagingengine.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> By any chance did you do that?

It will likely work with lilo -- it is file system independent as 
long as the file system implements the IOC_UNPACK ioctl, which
r4 seems to.

-Andi
