Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZDFThA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZDFThA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbZDFTgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:36:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757347AbZDFTgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:36:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: fix exit_ptrace() vs ptrace_traceme() race
In-Reply-To: Oleg Nesterov's message of  Monday, 6 April 2009 18:52:38 +0200 <20090406165238.GA25710@redhat.com>
References: <20090406165238.GA25710@redhat.com>
X-Zippy-Says: I think my CAREER is RUINED!!
Message-Id: <20090406193549.F13E8FC3E3@magilla.sf.frob.com>
Date: Mon,  6 Apr 2009 12:35:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
