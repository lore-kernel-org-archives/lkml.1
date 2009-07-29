Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbZG2WqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbZG2WqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 18:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbZG2WqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 18:46:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbZG2Wp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 18:45:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] do_signal_stop: do not call tracehook_notify_jctl() in
	TASK_STOPPED state
In-Reply-To: Oleg Nesterov's message of  Wednesday, 29 July 2009 03:48:22 +0200 <20090729014822.GA6201@redhat.com>
References: <20090729014822.GA6201@redhat.com>
X-Windows: the first fully modular software disaster.
Message-Id: <20090729224522.3C3364C791@magilla.sf.frob.com>
Date: Wed, 29 Jul 2009 15:45:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
