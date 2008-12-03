Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYLCX7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYLCX7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYLCX7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:59:04 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35357 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbYLCX7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:59:01 -0500
Date: Wed, 3 Dec 2008 17:58:58 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v10][PATCH 00/13] Kernel based checkpoint/restart
Message-ID: <20081203235858.GA27709@us.ibm.com>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> Checkpoint-restart (c/r): fixes a couple of bugs and a DoS issue
> (tested against v2.6.28-rc3).

Tests well for me.  Haven't tested mktree yet, will wait until you
re-send addressing feedback to do that.

thanks,
-serge
