Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbZEFCK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbZEFCK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZEFCKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:10:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbZEFCKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:10:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ptrace: do not use task_lock() for attach
In-Reply-To: Oleg Nesterov's message of  Wednesday, 6 May 2009 00:47:29 +0200 <20090505224729.GA965@redhat.com>
References: <20090505224729.GA965@redhat.com>
Emacs: featuring the world's first municipal garbage collector!
Message-Id: <20090506020837.3B9BFFC328@magilla.sf.frob.com>
Date: Tue,  5 May 2009 19:08:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
