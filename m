Return-Path: <linux-kernel-owner+w=401wt.eu-S1760276AbYBSByN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276AbYBSByN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 20:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbYBSBx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 20:53:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbYBSBx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 20:53:58 -0500
Date: Tue, 19 Feb 2008 01:53:44 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tilman Schmidt <tilman@imap.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc2 regression: LVM cannot find volume group
Message-ID: <20080219015344.GA4066@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Tilman Schmidt <tilman@imap.cc>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <47B73616.9050303@imap.cc> <20080216201206.1452cfe7@core> <47B765B1.1030709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B765B1.1030709@gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 11:37:37PM +0100, Jiri Slaby wrote:
> # CONFIG_SYSFS_DEPRECATED is not set

IMHO That should be *set* by default until everyone has had time to
update their userspace software to cope with the changed sysfs layout.

Alasdair
-- 
agk@redhat.com
