Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbYE2StY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbYE2StY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYE2StR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:49:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbYE2StQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:49:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.1.10.0805291123320.2958@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805291123320.2958@woody.linux-foundation.org> <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, bunk@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Werror: Fix casting wrong size integer to pointer
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 29 May 2008 19:48:28 +0100
Message-ID: <16606.1212086908@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I do not want to apply patches that just hide compiler warnings.

Well, will you at least consider patch 4?

Subject: [PATCH 4/6] Werror: Hide warnings on static module device tables

David
