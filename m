Return-Path: <linux-kernel-owner+w=401wt.eu-S1757679AbXENRYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679AbXENRYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbXENRYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:24:05 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54714 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492AbXENRYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:24:04 -0400
Date: Mon, 14 May 2007 19:23:12 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Howells <dhowells@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.22-rc1, 'nother randconfig
In-Reply-To: <21094.1179143087@redhat.com>
Message-ID: <Pine.LNX.4.61.0705141922470.9570@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705131125270.9570@yvahk01.tjqt.qr>
 <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
 <21094.1179143087@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 12:44, David Howells wrote:
>Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
>> net/built-in.o: In function `rxrpc_destroy_all_calls':
>> (.exit.text+0x71d): undefined reference to `rxrpc_call_states'
>> make: *** [.tmp_vmlinux1] Error 1
>
>This is the problem:
>
>	# CONFIG_PROC_FS is not set
>	CONFIG_AF_RXRPC=y

Are you going to fix it?



	Jan
-- 
