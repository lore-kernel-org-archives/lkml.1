Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbXLLPpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbXLLPpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759541AbXLLPlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:41:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759498AbXLLPla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:41:30 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com
Subject: [PATCH 0/6] paravirt patches - the non-integration part
Date: Wed, 12 Dec 2007 10:57:21 -0200
Message-Id: <11974642471600-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series corresponds do older patches in the paravirt series
that was neither already applied, nor I will touch again. In general,
they do not touch code that can be unified (at least, without being the
unification a big problem on its own).

They passed through this list a lot of times, so I feel them ready for
inclusion, unless someone opposes. 

As with the other patches, they apply to the top of linux-2.6-x86:mm 


