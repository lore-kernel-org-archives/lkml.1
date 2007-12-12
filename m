Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbXLLPil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbXLLPil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbXLLPid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:38:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbXLLPic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:38:32 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com
Subject: [PATCH 0/19] desc_struct integration
Date: Wed, 12 Dec 2007 10:53:45 -0200
Message-Id: <11974640441088-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1196957800568-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the last version of it received no comments on the interfaces, here
it goes a version, that I feel ready for inclusion.

The comments regarding style, specially the elimination of the #defines in
the desc_struct definition were merged. I also implemented the vmi
functions,
missing last time.

Ingo, in the absense of further complaints, could you please push to the
x86 tree?


