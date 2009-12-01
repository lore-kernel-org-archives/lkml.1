Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZLANZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZLANZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 08:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZLANZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 08:25:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbZLANZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 08:25:47 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200912011411.12570.s.L-H@gmx.de>
References: <200912011411.12570.s.L-H@gmx.de> <200911302259.nAUMx9Ij031249@hera.kernel.org>
To: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
Cc: dhowells@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       v9fs-developer@lists.sourceforge.net,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: FS-Cache: Handle pages pending storage that get evicted under OOM conditions
Date: Tue, 01 Dec 2009 13:24:42 +0000
Message-ID: <24956.1259673882@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:

> This commit breaks compiling 9p in 2.6.32-rc8-git2:

Yep.  I have two other patches for that so far.

David
