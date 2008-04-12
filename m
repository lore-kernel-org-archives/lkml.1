Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYDLWiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYDLWiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 18:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYDLWho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 18:37:44 -0400
Received: from nonada.if.usp.br ([143.107.131.169]:53951 "EHLO
	nonada.if.usp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbYDLWhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 18:37:43 -0400
Message-ID: <37696.200.161.218.109.1208039862.squirrel@143.107.131.169>
Date: Sat, 12 Apr 2008 19:37:42 -0300 (BRT)
Subject: Root on partitionable raid.
From: assirati@nonada.if.usp.br
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tried to boot a 2.6.25-rc8 kernel with ext3, raid1 and sata compiled in
(raid partitions marked as raid autodetect) and it cannot detect raid
partitions in boot time (it could not find my root that is a raid1
partition). I did not test rc9, but by the changelog the problem did not
got corrected.

2.6.24 works fine.

Thank you,
João.


