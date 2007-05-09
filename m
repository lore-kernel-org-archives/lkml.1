Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbXEIMXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbXEIMXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbXEIMXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:23:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbXEIMXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:23:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5d6222a80705090507h4fdbf4f5x439d3991c1c9b7b8@mail.gmail.com> 
References: <5d6222a80705090507h4fdbf4f5x439d3991c1c9b7b8@mail.gmail.com>  <20070509120201.6771.92968.stgit@warthog.cambridge.redhat.com> 
To: "Glauber de Oliveira Costa" <glommer@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a bad bug in read_cache_page_async() 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 09 May 2007 13:22:51 +0100
Message-ID: <11154.1178713371@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa <glommer@gmail.com> wrote:

> any reason for not simply returning page here?

Not particularly.

David
