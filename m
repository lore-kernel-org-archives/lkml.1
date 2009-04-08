Return-Path: <linux-kernel-owner+w=401wt.eu-S932885AbZDHSvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbZDHSvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932497AbZDHSvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:51:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51558 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765172AbZDHSvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:51:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <49DCEE63.2010103@goop.org>
References: <49DCEE63.2010103@goop.org> <21081.1239214221@redhat.com> <20090408183011.24150.43310.stgit@warthog.procyon.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: dhowells@redhat.com, mingo@elte.hu, akpm@linux-foundation.org,
       x86@kernel.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       nickpiggin@yahoo.com.au, tglx@linutronix.de, ysato@users.sourceforge.jp
Subject: Re: [PATCH] FRV: Use <asm-generic/pgtable.h> in NOMMU mode
Date: Wed, 08 Apr 2009 19:47:36 +0100
Message-ID: <24304.1239216456@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> OK, thanks.  Do you mind this patch going via tip.git?

No.

David
