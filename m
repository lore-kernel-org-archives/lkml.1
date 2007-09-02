Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbXIBJjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbXIBJjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 05:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXIBJi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 05:38:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37598 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbXIBJiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 05:38:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Prakash Punnoor <prakash@punnoor.de>
Subject: Re: Linux 2.6.23-rc5
Date: Sun, 2 Sep 2007 11:49:42 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0708312343440.27951@evo.linux-foundation.org> <200709020954.08285.prakash@punnoor.de>
In-Reply-To: <200709020954.08285.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709021149.42733.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 2 September 2007 09:54, Prakash Punnoor wrote:
> Hi,
> 
> 2.6.23-rc5 locks up hard (Magic Syskeys won't even work) after a few minutes 
> of work on x86_64. 2.6.23-rc4 was fine. I'll try git-bisect to find out what 
> is causing trouble. Yes, I am using nvidia binary but it didn't make troubles 
> since ages... When I found the bugger, I'll try whether it works w/o nvidia 
> binary.

Just for the record, I'm running -rc5 on two x86_64 boxes without any visible
issue.

I don't use any binary graphics drivers, though.

Greetings,
Rafael
