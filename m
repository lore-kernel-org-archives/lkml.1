Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbYJ0WDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbYJ0WDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYJ0WD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:03:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbYJ0WD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:03:28 -0400
Date: Mon, 27 Oct 2008 15:02:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dean Nelson <dcn@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sgi-xp: only build for ia64-sn2 when
 CONFIG_IA64_GENERIC specified v.2
Message-Id: <20081027150256.8fb5bc19.akpm@linux-foundation.org>
In-Reply-To: <20081023183335.GA24139@sgi.com>
References: <20081023183335.GA24139@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 13:33:35 -0500
Dean Nelson <dcn@sgi.com> wrote:

> For the time being build for ia64-sn2 alone when CONFIG_IA64_GENERIC is
> specified.
> 

It is 100% unclear (to me) why this change is being made.

Apparently this is considered a needed-in-2.6.28 change.  But I don't
know why.

If I knew that then I'd be in a better position to work out whether it
is also needed in 2.6.27.x, to which it also applies cleanly.

IOW: better changelogs, please.

