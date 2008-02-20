Return-Path: <linux-kernel-owner+w=401wt.eu-S1762438AbYBTSNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762438AbYBTSNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYBTSNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:13:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYBTSNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:13:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080220175145.GA6733@cvg>
References: <20080220175145.GA6733@cvg> <20080218200302.GA6741@cvg> <19148.1203512465@redhat.com> <20080220131442.GA18790@uranus.ravnborg.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: dhowells@redhat.com, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [QUESTION] FRV: linking error?
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 20 Feb 2008 18:13:15 +0000
Message-ID: <11226.1203531195@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Sam, maybe we should just eliminate this section at least for FRV?

You should have a patch in your inbox to do just that.

David
