Return-Path: <linux-kernel-owner+w=401wt.eu-S934903AbYBUQvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934903AbYBUQvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935106AbYBUQvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:51:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935094AbYBUQvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:51:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080221164911.16476.12046.stgit@warthog.procyon.org.uk>
References: <20080221164911.16476.12046.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       zippel@linux-m68k.org, schwab@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make the kernel NTP code hand 64-bit *unsigned* values to do_div() [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 21 Feb 2008 16:51:13 +0000
Message-ID: <16611.1203612673@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Subject: [PATCH] Make the kernel NTP code hand 64-bit *unsigned* values to
> 	do_div() [try #2]

Ignore try #2.  I forgot to commit the changes before mailing.

David
