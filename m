Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbZLRKMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbZLRKMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 05:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZLRKMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 05:12:36 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:62068 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbZLRKMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 05:12:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=kEHAK6mX5thmDvVqDFUobrn7+8LWMFv3vpZVw46Znq0QsGSsadSaHtu1kZNt85uDo/
         QU6f+HeELATUO8iBoYZCw3ZDEA15Y5LTZMB0ig4WxAE4RdNYdhMgGB8Q72xRIatYwSbv
         aQ5uocy/3eycbSy2h4e7Ha46e2KY01a7qAGkw=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: what's node "-1" ?
Date: Fri, 18 Dec 2009 11:12:30 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc1-dirty; KDE/4.3.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912181112.30586.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[   22.284175]   alloc irq_desc for 55 on node -1
[   22.284177]   alloc kstat_irqs on node -1

What's node "-1" ?

dmesg talks about nodes such things:
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:8 nr_node_ids:1
[    0.073337] CPU 0/0x0 -> Node 0

there is some "node 0" ... but no idea what -1 is.

(2.6.32.1)
-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
