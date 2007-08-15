Return-Path: <linux-kernel-owner+w=401wt.eu-S1764988AbXHONBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764988AbXHONBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761924AbXHOMzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:55:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759491AbXHOMzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:55:17 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com
Subject: [PATCH 0/25][V3] pvops_64 last round (hopefully)
Date: Wed, 15 Aug 2007 09:49:20 -0300
Message-Id: <11871821854176-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is hopefully the last iteration of the pvops64 patch.

>From the last version, we have only one change, which is include/asm-x86_64/processor.h: There were still one survivor in raw asm.
Also, git screwed me up for some reason, and the 25th patch was missing the new files, paravirt.{c,h}. (although I do remember having git-add'ed it, but who knows...)

Andrew, could you please push it to -mm ?

Have fun!
