Return-Path: <linux-kernel-owner+w=401wt.eu-S1762466AbZBECAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762466AbZBECAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbZBECAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:00:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756604AbZBECAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:00:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] reparent_thread: don't call kill_orphaned_pgrp() if
	task_detached()
In-Reply-To: Oleg Nesterov's message of  Thursday, 29 January 2009 09:05:55 +0100 <20090129080555.GA26867@redhat.com>
References: <20090129080555.GA26867@redhat.com>
X-Zippy-Says: HERE!!  Put THIS on!!  I'm in CHARGE!!
Message-Id: <20090205020010.4BDFAFC381@magilla.sf.frob.com>
Date: Wed,  4 Feb 2009 18:00:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
