Return-Path: <linux-kernel-owner+w=401wt.eu-S1759668AbYHTPIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668AbYHTPIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYHTPIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:08:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728AbYHTPIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:08:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <a4423d670808200721i3e9add4cn216da7991f0616f3@mail.gmail.com>
References: <a4423d670808200721i3e9add4cn216da7991f0616f3@mail.gmail.com> <20080820135624.10583.99230.stgit@warthog.procyon.org.uk>
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Cc: dhowells@redhat.com, jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] CRED: Further fix execve error handling
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 20 Aug 2008 16:07:26 +0100
Message-ID: <24497.1219244846@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov <a.beregalov@gmail.com> wrote:

> David, I applied this patch and got the following.
> Is it a different problem?
> I think it is. If yes I will create another topic.

It doesn't look like it's anything to do with my patches.  I'd guess the TTY
patches from Alan Cox are the culprit.

David


