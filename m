Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbZD2Trs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbZD2Trs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZD2Tri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:47:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZD2Trh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:47:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] elf_core_dump: use rcu_read_lock() to access ->real_parent
In-Reply-To: Oleg Nesterov's message of  Wednesday, 29 April 2009 11:07:46 +0200 <20090429090746.GA8284@redhat.com>
References: <20090429090746.GA8284@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090429194658.8F36FFC3BF@magilla.sf.frob.com>
Date: Wed, 29 Apr 2009 12:46:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
