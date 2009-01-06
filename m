Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZAFUGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZAFUGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZAFUF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:05:56 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41857 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbZAFUFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:05:55 -0500
Subject: Re: [RFC v12][PATCH 00/14] Kernel based checkpoint/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Mike Waychison <mikew@google.com>
In-Reply-To: <1230542187-10434-1-git-send-email-orenl@cs.columbia.edu>
References: <1230542187-10434-1-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 12:05:28 -0800
Message-Id: <1231272328.23462.43.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-29 at 04:16 -0500, Oren Laadan wrote:
> Checkpoint-restart (c/r): fixed issues in error path handling (comments
> from Mike Waychison) and . Updated and tested against v2.6.28
> 
> We'd like to push these into -mm.

Hey Andrew, I think we've exhausted all the reviewers on this one, and
all the comments have been addressed.  How about a spin in -mm?

-- Dave

