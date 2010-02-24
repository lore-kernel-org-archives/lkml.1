Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0BXIov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:44:51 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:45774 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab0BXIos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:44:48 -0500
Message-Id: <20100224084430.193562869@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 24 Feb 2010 09:44:30 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 00/32] s390 patch queue for 2.6.34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,
we are closing in on 2.6.33 so it is time for the usual s390 patch
bomb. 32 patches are waiting on the features branch of git390 right
now, mostly boring stuff. Two patches are intersting though:
the spinlock improvement that checks for the virtual cpu running
status of the lock holder and the kernel image compression (yes, we
finally have kernel image compression after only 10 years..)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.
