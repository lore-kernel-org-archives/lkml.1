Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbZD2SNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbZD2SNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 14:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZD2SNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 14:13:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbZD2SNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 14:13:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: s/parent/real_parent/ in binfmt_elf_fdpic.c
In-Reply-To: Oleg Nesterov's message of  Wednesday, 29 April 2009 00:30:50 +0200 <20090428223050.GA12020@redhat.com>
References: <20090428223050.GA12020@redhat.com>
Emacs: because one operating system isn't enough.
Message-Id: <20090429181242.CC2DCFC3BF@magilla.sf.frob.com>
Date: Wed, 29 Apr 2009 11:12:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
