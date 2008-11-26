Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYKZBG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYKZBG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 20:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYKZBFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 20:05:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbYKZBFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 20:05:44 -0500
Date: Tue, 25 Nov 2008 17:03:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com,
       kay.sievers@vrfy.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
       mingo@elte.hu, mtk.manpages@gmail.com
Subject: Re: LinuxPPS (Version 9): the PPS Linux implementation.
Message-Id: <20081125170344.98ee3103.akpm@linux-foundation.org>
In-Reply-To: <1227647470-4816-1-git-send-email-giometti@linux.it>
References: <1227647470-4816-1-git-send-email-giometti@linux.it>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 22:11:06 +0100
Rodolfo Giometti <giometti@linux.it> wrote:

> This patch set adds the PPS support into Linux.

I'm having way too much trouble getting all this to apply on
2.6.28-rc6, let alone linux-next.

Please redo everything against the latest Linus tree and resend
everything with full changelogs, etc.

You could even redo the patches against linux-next, which is after all
our candidate 2.6.29 tree.  But afacit there are few conflicting
changes in there at this time, apart from the fact that lots of files
have been moved into different directories, but that's a relatively
minor thing.


