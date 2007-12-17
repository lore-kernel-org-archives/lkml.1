Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbXLRBga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbXLRBga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbXLRBgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:36:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbXLRBgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:36:20 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com
Subject: [PATCH 0/21] Integrate processor.h
Date: Mon, 17 Dec 2007 20:52:23 -0200
Message-Id: <11979319641796-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series integrate the processor.h header. There are a lot of things
that are deeply architectural differences between architectures, but
I've done my best to come to a settlement. 

With this series, I am very close to have selectable paravirt for x86_64,
It applies ontop of today's x86 git, mm branch.

 

