Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZBWPxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZBWPxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbZBWPxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:53:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57328 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056AbZBWPxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:53:38 -0500
Date: Mon, 23 Feb 2009 16:50:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/4] forget_original_parent: misc
Message-ID: <20090223155012.GA16078@redhat.com>
References: <20090211211212.GA16839@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211211212.GA16839@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11, Oleg Nesterov wrote:
>
> this series tries to address Roland's comments/suggestions.

Andrew, please drop

	move-exit_ptrace-from-forget_original_parent-to-do_exit.patch
	reparent-untrace-do-nothing-if-no-childs-tracees.patch

As Roland pointed out, they should be changed.

Oleg.

