Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYCaDNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYCaDNf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 23:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYCaDN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 23:13:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43229 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYCaDN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 23:13:27 -0400
Date: Mon, 31 Mar 2008 04:13:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Bernd Eckenfels <ecki@lina.inka.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC:   Writing Solaris Device Drivers in Java
Message-ID: <20080331031326.GJ9785@ZenIV.linux.org.uk>
References: <47F0491F.4050804@gmail.com> <E1JgAEe-0006hb-00@calista.eckenfels.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JgAEe-0006hb-00@calista.eckenfels.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 04:59:00AM +0200, Bernd Eckenfels wrote:
> In article <47F0491F.4050804@gmail.com> you wrote:
> > (Windows/MacOS/Linux/BSD etc).   Ie, imagine using a drivers written for 
> > the Solaris in Linux, won't it be cool?
> 
> I think the device driver reuse between the various C-kernels is pretty big.
> For efficiency and since the low level stuff is a major part of device
> drivers, I cant see a Java solution. I guess we would see drivers in Forth before :)

Don't forget assembler converted to binary by bash(1) and a stunning
innovation of . added in front of directory names...

[if you want to summon you-know-what, might as well do that properly]
