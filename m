Return-Path: <linux-kernel-owner+w=401wt.eu-S1762402AbXJOKEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762402AbXJOKEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 06:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbXJOKD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 06:03:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbXJOKDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 06:03:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <E1Ih8Iw-00042W-7v@ZenIV.linux.org.uk>
References: <E1Ih8Iw-00042W-7v@ZenIV.linux.org.uk>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] frv: missing casts in cmpxchg()
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Mon, 15 Oct 2007 11:03:44 +0100
Message-ID: <6048.1192442624@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ftp.linux.org.uk> wrote:

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: David Howells <dhowells@redhat.com>
