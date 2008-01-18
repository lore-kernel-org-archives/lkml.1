Return-Path: <linux-kernel-owner+w=401wt.eu-S1765605AbYARUEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765605AbYARUEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763506AbYARUET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:04:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763288AbYARUES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:04:18 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com
Subject: [PATCH 0/10] Tree fixes for PARAVIRT
Date: Fri, 18 Jan 2008 15:20:15 -0200
Message-Id: <12006768251548-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This small series provides some more fixes towards the goal
to have the PARAVIRT selectable for x86_64. After that, just
some more small steps are needed.

The first fix is not even specific for PARAVIRT, and it's actually
preventing the whole tree from booting.


