Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbXJ3OTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbXJ3OTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 10:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755760AbXJ3OSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 10:18:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678AbXJ3OSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 10:18:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <15675.1193753820@redhat.com>
References: <15675.1193753820@redhat.com> <4726337B.1080608@l4x.org> <4725B553.4060502@l4x.org> <4220.1193663179@redhat.com>
To: Jan Dittmer <jdi@l4x.org>
Cc: dhowells@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Working frv toolchain?
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 30 Oct 2007 14:18:44 +0000
Message-ID: <15712.1193753924@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


David Howells <dhowells@redhat.com> wrote:

> Ah... I'd forgotten about that.  I'm not sure all the ASM constraint changes
> are upstream yet, and gcc bz 28583 also gets incurred.  Are you particularly
> interested in building your own compiler, or would one of ours do?

Look in:

	ftp://ftp.redhat.com/pub/redhat/gnupro/FRV

David
