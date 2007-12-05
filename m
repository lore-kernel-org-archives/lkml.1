Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbXLEMYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbXLEMYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 07:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbXLEMYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 07:24:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbXLEMYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 07:24:10 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071205083856.GG8181@ftp.linux.org.uk>
References: <20071205083856.GG8181@ftp.linux.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fcrypt endianness misannotations
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 05 Dec 2007 12:23:58 +0000
Message-ID: <18847.1196857438@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> wrote:

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

I've checked it and it still works with this patch.

Acked-by: David Howells <dhowells@redhat.com>
