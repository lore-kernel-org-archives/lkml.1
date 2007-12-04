Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbXLDSvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbXLDSvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbXLDSuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:50:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbXLDSui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:50:38 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com
Subject: [PATCH 0/8] Integrate system.h
Date: Tue,  4 Dec 2007 14:06:20 -0200
Message-Id: <11967843881946-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the same lines of the msr.h integration, here it goes a series for
system.h. Again, after the headers are turned into one, the paravirt
pieces related to system.h comes for free.



