Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbXE3WLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbXE3WLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758441AbXE3WLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:11:16 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49540 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757909AbXE3WLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:11:14 -0400
Date: Thu, 31 May 2007 00:11:10 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.52
Message-ID: <20070530221110.GW3899@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.51:

Adrian Bunk (2):
      Linux 2.6.16.52-rc1
      Linux 2.6.16.52

Andrew Morton (1):
      gcc-4.1.0 is bust

Corey Mutter (1):
      [IPV6]: Reverse sense of promisc tests in ip6_mc_input

David L Stevens (1):
      [IPV6]: Send ICMPv6 error on scope violations.

Eric Sesterhenn (1):
      [IPV6]: Fix slab corruption running ip6sic

Jamal Hadi Salim (1):
      [NET_SCHED]: prio qdisc boundary condition

Sergei Shtylyov (2):
      [NETPOLL]: Fix TX queue overflow in trapped mode.
      [NETPOLL]: Remove CONFIG_NETPOLL_RX

Srinivas Aji (1):
      [TCP]: zero out rx_opt in tcp_disconnect()

Stephen Hemminger (1):
      [IPV6]: Track device renames in snmp6.


 Makefile                  |    2 +-
 drivers/net/Kconfig       |    5 -----
 include/linux/netdevice.h |    8 +++-----
 init/main.c               |    4 ++++
 net/ipv4/tcp.c            |    3 +--
 net/ipv6/addrconf.c       |    6 ++++--
 net/ipv6/ip6_input.c      |    2 +-
 net/ipv6/ip6_output.c     |   13 ++++++++++---
 net/ipv6/proc.c           |    1 +
 net/ipv6/xfrm6_tunnel.c   |    2 +-
 net/sched/sch_prio.c      |    2 +-
 11 files changed, 27 insertions(+), 21 deletions(-)

