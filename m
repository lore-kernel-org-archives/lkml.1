Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbXFBJY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbXFBJY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 05:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbXFBJYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 05:24:19 -0400
Received: from mail.websurfer.com.np ([63.219.0.28]:35171 "EHLO
	mail.websurfer.com.np" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbXFBJYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 05:24:19 -0400
X-Antivirus-MYDOMAIN-Mail-From: umesh@websurfer.com.np via mail.websurfer.com.np
X-Antivirus-MYDOMAIN: 1.25-st-qms (Clear:RC:1(63.219.0.28):. Processed in 0.056262 secs Process 28420)
Message-ID: <2658.63.219.2.2.1180776292.squirrel@mail.websurfer.com.np>
Date: Sat, 2 Jun 2007 15:09:52 +0545 (NPT)
Subject: kernel Error
From: umesh@websurfer.com.np
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I got following error message when I try to upload file to remote server.
The log generated in remote server is as per below.

KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c (1284)
recvmsg bug: copied BC00D548 seq BC00DAFC
KERNEL: assertion (tp->copied_seq == tp->rcv_nxt || (flags & (MSG_PEEK |
MSG_TRUNC))) failed at net/ipv4/tcp.c (1348)
KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c (1284)
recvmsg bug: copied BC00D548 seq BC00DAFC
KERNEL: assertion (tp->copied_seq == tp->rcv_nxt || (flags & (MSG_PEEK |
MSG_TRUNC))) failed at net/ipv4/tcp.c (1348)
KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c (1284)

Umesh

