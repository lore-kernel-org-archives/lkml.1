Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbYGKWsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbYGKWsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 18:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYGKWsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 18:48:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbYGKWsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 18:48:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080711122056.8b36c084.akpm@linux-foundation.org>
References: <20080711122056.8b36c084.akpm@linux-foundation.org> <20080708154416.24850.30733.stgit@warthog.procyon.org.uk> <20080708171029.08db0f4d@the-village.bc.nu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a const assignment in moxa_load_fw()
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Fri, 11 Jul 2008 23:48:21 +0100
Message-ID: <26525.1215816501@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Appears to already be fixed in linux-next, perhaps by this:

Some of the maintainers have already pushed through the patches I've sent to
you and them.

David
