Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZD0COU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZD0COU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 22:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbZD0COF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 22:14:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZD0COE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 22:14:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Hugh Dickins <hugh@veritas.com>,
       stable@kernel.org
Subject: Re: [PATCH] ptrace: ptrace_attach: fix the usage of ->cred_exec_mutex
In-Reply-To: Oleg Nesterov's message of  Monday, 27 April 2009 01:41:34 +0200 <20090426234134.GA13391@redhat.com>
References: <20090425172524.GA3432@redhat.com>
	<20090424163949.GA12035@redhat.com>
	<20090423212250.GA22537@redhat.com>
	<20090423232717.975ABFC3C7@magilla.sf.frob.com>
	<31842.1240656853@redhat.com>
	<394.1240686417@redhat.com>
	<20090426234134.GA13391@redhat.com>
Emacs: a Lisp interpreter masquerading as ... a Lisp interpreter!
Message-Id: <20090427021138.2A759FC3B6@magilla.sf.frob.com>
Date: Sun, 26 Apr 2009 19:11:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
