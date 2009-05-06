Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbZEFUBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbZEFUBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbZEFUBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:01:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbZEFUBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:01:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: [FOR REVIEW, PATCH 1/2] shift "ptrace implies WUNTRACED" from
	ptrace_do_wait() to wait_task_stopped()
In-Reply-To: Oleg Nesterov's message of  Wednesday, 6 May 2009 07:33:22 +0200 <20090506053322.GA31981@redhat.com>
References: <20090506053322.GA31981@redhat.com>
X-Zippy-Says: ..  Now KEN and BARBIE are PERMANENTLY ADDICTED to MIND-ALTERING DRUGS..
Message-Id: <20090506200116.867D5FC39E@magilla.sf.frob.com>
Date: Wed,  6 May 2009 13:01:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the whitespace/punctuation in the comment back to match the old one,
which had the normal style.  Other than that,
Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland
