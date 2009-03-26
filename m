Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbZCZSGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbZCZSGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 14:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbZCZSGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 14:06:41 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:40599 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754529AbZCZSGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 14:06:40 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-05.arcor-online.net 4A05C33295E
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: ext3 IO latency measurements
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Theodore Tso <tytso@mit.edu>
Reply-To: 7eggert@gmx.de
Date: Thu, 26 Mar 2009 19:06:33 +0100
References: <cjCU5-1QB-11@gated-at.bofh.it> <cjFfc-5tr-13@gated-at.bofh.it> <cjGuK-7mU-39@gated-at.bofh.it> <cjImV-1Wa-27@gated-at.bofh.it> <cjJiR-3rY-9@gated-at.bofh.it> <cjKHX-5MF-17@gated-at.bofh.it> <cjLb2-6no-13@gated-at.bofh.it> <cjTLl-3ln-15@gated-at.bofh.it> <cjW6r-72f-21@gated-at.bofh.it> <cjYrG-2u0-23@gated-at.bofh.it> <cjZ4h-3jp-19@gated-at.bofh.it> <ck0D8-5Ua-11@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LmtyL-0001RC-GJ@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> brains, and we'd better change the default - and if some distro really
> _thinks_ about it, and decides that they really want old-fashioned atime,
> let them do that".

That's something a 2.7 kernel series might do - collect all sane defaults
you wished to set all the time.

