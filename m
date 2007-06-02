Return-Path: <linux-kernel-owner+w=401wt.eu-S1761422AbXFBQFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422AbXFBQFQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 12:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbXFBQFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 12:05:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:52266 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbXFBQFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 12:05:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=UO2eBRmy7VDdVk30+EYptCZSvINFXU35TIpO5KiNV/2J6l9GL5DrqZhBtu8nfCTrZYxAbSlyJqDv1W7Qe+UgqUYVsd0+ktbZLBkNWIkYuLU+4UtMgZNVXTLttJWOaIYFoM8IMt18g8P+QF3ruiYuNTbfveEbEUslBbrF7ww6NA0=
Message-ID: <4661951D.4010904@googlemail.com>
Date: Sat, 02 Jun 2007 18:04:45 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: umesh@websurfer.com.np
CC: linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: kernel Error
References: <2658.63.219.2.2.1180776292.squirrel@mail.websurfer.com.np>
In-Reply-To: <2658.63.219.2.2.1180776292.squirrel@mail.websurfer.com.np>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[netdev added to CC]

umesh@websurfer.com.np pisze:
> I got following error message when I try to upload file to remote server.
> The log generated in remote server is as per below.
> 
> KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c (1284)
> recvmsg bug: copied BC00D548 seq BC00DAFC
> KERNEL: assertion (tp->copied_seq == tp->rcv_nxt || (flags & (MSG_PEEK |
> MSG_TRUNC))) failed at net/ipv4/tcp.c (1348)
> KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c (1284)
> recvmsg bug: copied BC00D548 seq BC00DAFC
> KERNEL: assertion (tp->copied_seq == tp->rcv_nxt || (flags & (MSG_PEEK |
> MSG_TRUNC))) failed at net/ipv4/tcp.c (1348)
> KERNEL: assertion (flags & MSG_PEEK) failed at net/ipv4/tcp.c (1284)
> 
> Umesh
> 

Please read REPORTING-BUGS and send more details

Regards,
Michal

-- 
"Najbardziej brakowało mi twojego milczenia."
-- Andrzej Sapkowski "Coś więcej"

