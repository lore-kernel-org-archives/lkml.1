Return-Path: <linux-kernel-owner+w=401wt.eu-S1761503AbXEJTFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbXEJTFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757436AbXEJTFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:05:45 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757405AbXEJTFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:05:44 -0400
Date: Thu, 10 May 2007 12:04:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Neil Brown <neilb@suse.de>,
       linux-raid@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Greaves <david@dgreaves.com>, Doug Ledford <dledford@redhat.com>
Subject: Re: Please revert 5b479c91da90eef605f851508744bfe8269591a0 (md
 partition rescan)
Message-Id: <20070510120435.4b44af90.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0705101650340.24536@yvahk01.tjqt.qr>
References: <17986.26930.952993.510918@notabene.brown>
	<alpine.LFD.0.98.0705091848370.4062@woody.linux-foundation.org>
	<Pine.LNX.4.61.0705101650340.24536@yvahk01.tjqt.qr>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 16:51:31 +0200 (MEST) Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> On May 9 2007 18:51, Linus Torvalds wrote:
> >
> >(But Andrew never saw your email, I suspect: "akpm@suse.de" is probably 
> >some strange mixup of Andrew Morton and Andi Kleen in your mind ;)
> 
> What do the letters kp stand for?
> 

Some say "Kernel Programmer".  My parents said "Keith Paul".
