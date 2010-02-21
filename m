Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0BUXkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 18:40:47 -0500
Received: from cgp-fe01.mtu.ru ([62.5.255.15]:38333 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753379Ab0BUXkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 18:40:45 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 18:40:45 EST
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc
To: linux-kernel@vger.kernel.org
Subject: NET-PF-27 & NET-PF-28
Date: Mon, 22 Feb 2010 02:25:40 +0300
User-Agent: KMail/1.12.4 (Linux/2.6.32.8-grsec; KDE/4.3.5; x86_64; ; )
X-Face: $dO4505L-bM3\Iz"(V=y.bL/75{5ys3:B[-aPBQvs*Z%fdBqFhvc85hmZN4j1kwRzwvY*R
	4	nvQ/#/+kWXH((aXWh\%mvG1V()Z0k:NwZAIu\S0d1%,nv`^
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002220225.40260.pavel@pavlinux.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/include/linux/socket.h 

#define AF_WANPIPE   25      /* Wanpipe API Sockets      */
#define AF_LLC        26      /* Linux LLC                 */
#define AF_CAN        29     /* Controller Area Network  */
#define AF_TIPC        30     /* TIPC sockets              */


Where is number 27 and 28 address and protocol family's ?
