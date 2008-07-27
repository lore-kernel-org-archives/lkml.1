Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbYG0LAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbYG0LAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 07:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYG0LAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 07:00:24 -0400
Received: from smtp7.tech.numericable.fr ([82.216.111.43]:40458 "EHLO
	smtp7.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYG0LAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 07:00:23 -0400
Message-ID: <488C5545.5010309@numericable.fr>
Date: Sun, 27 Jul 2008 13:00:21 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird 3.0a1 (X11/2008051919)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.26-git15] Cannot open "/proc/sys/net/ipv4/route/flush"
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,


After compiling the very latest git kernel this morning, I have this 
message on boot (on Gentoo box) :

Bringing up interface lo
     127.0.0.1/8 ...
     Adding routes
         127.0.0.0/8 via 127.0.0.1 ...
Cannot open "/proc/sys/net/ipv4/route/flush"

Do I put
/proc/sys/net/ipv4/route/flush=1
or
net.ipv4.conf.all.accept_source_route = 1

in my sysctl.conf file ?

Regards.


