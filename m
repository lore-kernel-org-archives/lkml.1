Return-Path: <linux-kernel-owner+w=401wt.eu-S1764206AbXLRFgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764206AbXLRFgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 00:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXLRFfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 00:35:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbXLRFfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 00:35:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
X-Fcc: ~/Mail/linus
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com
Subject: Re: [PATCH 3/21] [PATCH] move desc_empty to where they belong
In-Reply-To: Rusty Russell's message of  Tuesday, 18 December 2007 16:14:36 +1100 <200712181614.37890.rusty@rustcorp.com.au>
References: <11979319641796-git-send-email-gcosta@redhat.com>
	<11979319763641-git-send-email-gcosta@redhat.com>
	<11979319811234-git-send-email-gcosta@redhat.com>
	<200712181614.37890.rusty@rustcorp.com.au>
X-Shopping-List: (1) Ambidextrous explosions
   (2) Compliant sporadic royalty proteins
   (3) Fluorescent persuaders
   (4) Unopened swindlers
   (5) State-supported sarcastic witches
Message-Id: <20071218053508.BB73526F98A@magilla.localdomain>
Date: Mon, 17 Dec 2007 21:35:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll have a TLS cleanup patch soon that makes the (only) use of desc_empty
pass a struct user_desc pointer.

Thanks,
Roland
