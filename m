Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbYDTWR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbYDTWR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 18:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbYDTWRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 18:17:49 -0400
Received: from quechua.inka.de ([193.197.184.2]:51546 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbYDTWRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 18:17:49 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: x86: 4kstacks default
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <480BB85A.6020508@firstfloor.org>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1Jnhr0-00076D-00@calista.eckenfels.net>
Date: Mon, 21 Apr 2008 00:17:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <480BB85A.6020508@firstfloor.org> you wrote:
> If you claim that works on a 32bit system with typically 300-600MB
> lowmem available (which is also shared by other subsystem) I know who
> sounds foolish.

A question along this line. Why is the Userspace Thread bound to a
Kernel-Space Stack at all? I could imagine a solution like Stack Pools
assigned only of a Thread enters kernel space, or something like this?

Gruss
Bernd
