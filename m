Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbXE3RmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbXE3RmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbXE3RmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:42:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24447 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbXE3RmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:42:15 -0400
Date: Wed, 30 May 2007 10:40:25 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] lock contention tracking -v4
Message-ID: <20070530174025.GD5488@mami.zabbo.net>
References: <20070530124903.882133089@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530124903.882133089@chello.nl>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 02:49:03PM +0200, Peter Zijlstra wrote:
> 
> Use the lockdep infrastructure to track lock contention and other lock
> statistics.

I really like the sound of this.

Has anyone given you an indication of when it might be merged?

- z
