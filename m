Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbXEAPch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbXEAPch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXEAPch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:32:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbXEAPcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:32:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0705011709320.3055@anakin> 
References: <Pine.LNX.4.64.0705011709320.3055@anakin> 
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: AF_RXRPC depends on KEYS? 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 01 May 2007 16:32:31 +0100
Message-ID: <30031.1178033551@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Should AF_RXRPC depend on KEYS?

Ummm... yes it probably should.  It's just that I normally build rxkad too,
and that does depend on keys.

David
