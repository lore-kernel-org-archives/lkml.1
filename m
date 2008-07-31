Return-Path: <linux-kernel-owner+w=401wt.eu-S1762767AbYGaDCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762767AbYGaDCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763205AbYGaDAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:00:40 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:63144 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761032AbYGaDAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:00:38 -0400
Date: Wed, 30 Jul 2008 22:54:25 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: 2.6.27-rc1 + selinux new options = no httpd
To: linux-kernel@vger.kernel.org
Message-id: <200807302254.26036.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

I just had to reboot backwards to 2.6.26 as I don't seem to be able to turn 
off enough selinux stuff to allow apache (httpd) to run, on 2.6.27-rc1 it 
cannot get perms to access its log files so it exits.

Is there a specific fix for this?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Heuristics are bug ridden by definition.  If they didn't have bugs,
then they'd be algorithms.
