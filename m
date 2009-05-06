Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbZEFB53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbZEFB53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 21:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZEFB5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 21:57:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbZEFB5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 21:57:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace_get_task_struct: s/tasklist/rcu/, make it static
In-Reply-To: Oleg Nesterov's message of  Wednesday, 6 May 2009 01:28:20 +0200 <20090505232820.GA4377@redhat.com>
References: <20090505232820.GA4377@redhat.com>
X-Windows: you'll envy the dead.
Message-Id: <20090506015635.557D3FC328@magilla.sf.frob.com>
Date: Tue,  5 May 2009 18:56:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
