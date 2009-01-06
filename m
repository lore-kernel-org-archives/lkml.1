Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZAFUXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZAFUXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZAFUXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:23:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651AbZAFUXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:23:34 -0500
Date: Tue, 6 Jan 2009 12:23:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: orenl@cs.columbia.edu, torvalds@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org, tglx@linutronix.de,
       serue@us.ibm.com, mingo@elte.hu, hpa@zytor.com, viro@zeniv.linux.org.uk,
       mikew@google.com
Subject: Re: [RFC v12][PATCH 00/14] Kernel based checkpoint/restart
Message-Id: <20090106122301.db538734.akpm@linux-foundation.org>
In-Reply-To: <1231272328.23462.43.camel@nimitz>
References: <1230542187-10434-1-git-send-email-orenl@cs.columbia.edu>
	<1231272328.23462.43.camel@nimitz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2009 12:05:28 -0800
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Mon, 2008-12-29 at 04:16 -0500, Oren Laadan wrote:
> > Checkpoint-restart (c/r): fixed issues in error path handling (comments
> > from Mike Waychison) and . Updated and tested against v2.6.28
> > 
> > We'd like to push these into -mm.
> 
> Hey Andrew, I think we've exhausted all the reviewers on this one, and
> all the comments have been addressed.  How about a spin in -mm?
> 

I'll take a look soonish.  Now is not a good time to be merging new
features into anything..
