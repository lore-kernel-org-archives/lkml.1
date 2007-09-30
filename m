Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbXI3WGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbXI3WGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbXI3WF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:05:59 -0400
Received: from mx1.suse.de ([195.135.220.2]:36831 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbXI3WF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:05:58 -0400
To: "Jaswinder Singh" <jaswinderlinux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22.7 default kernel configuration
References: <3f9a31f40709240411u1cc56559o90dca73ce79abf5a@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Oct 2007 00:05:56 +0200
In-Reply-To: <3f9a31f40709240411u1cc56559o90dca73ce79abf5a@mail.gmail.com>
Message-ID: <p73zlz37qrf.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Jaswinder Singh" <jaswinderlinux@gmail.com> writes:
> 
> By default configuration size of vmlinux is 41 MB and it includes
> approx 75% of useless stuff for me.

That's not a i386 or x86-64 defconfig. i386 and x86-64 defconfigs
are ~6.1MB and ~12MB.

-Andi
