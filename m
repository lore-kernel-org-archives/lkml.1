Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbXLERxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbXLERxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXLERxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:53:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbXLERxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:53:16 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com
Subject: [PATCH 0/9 - v2] Integrate system.h
Date: Wed,  5 Dec 2007 13:08:24 -0200
Message-Id: <1196867313972-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: 20071204204931.GC32018@elte.hu
References: 20071204204931.GC32018@elte.hu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

At Ingo's request, here it goes a new patchset, that actually
applies ontop of the x86 tree (mm branch). Besides this issue, 
I've also included a patch that remove the cr8 references, as Andi
suggested.


