Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbYAUVxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbYAUVxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYAUVxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:53:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbYAUVxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:53:14 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com
Subject: [PATCH 0/4] paravirt_ops-64 compile fixes
Date: Mon, 21 Jan 2008 19:48:49 -0200
Message-Id: <1200952133-31581-1-git-send-email-ehabkost@redhat.com>
X-Mailer: git-send-email 1.5.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contain fixes to make the paravirt_ops code compile and boot
on x86_64.

This is a follow-up for the previous series from Glauber.
