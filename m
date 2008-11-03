Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbYKCUz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbYKCUz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbYKCUzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:55:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756295AbYKCUzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:55:43 -0500
Date: Mon, 3 Nov 2008 12:55:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <jbacik@redhat.com>
Cc: jbacik@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       rwheeler@redhat.com
Subject: Re: [PATCH] improve jbd fsync batching
Message-Id: <20081103125509.41e55529.akpm@linux-foundation.org>
In-Reply-To: <20081103202442.GA25736@unused.rdu.redhat.com>
References: <20081028201614.GA21600@unused.rdu.redhat.com>
	<20081103122729.60582692.akpm@linux-foundation.org>
	<20081103202442.GA25736@unused.rdu.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2008 15:24:43 -0500
Josef Bacik <jbacik@redhat.com> wrote:

> > please fix.
> 
> I see you already pulled this into -mm, would you like me to repost with the
> same changelog and the patch updated, or just reply to this with the updated
> patch?  Thanks,

Either works for me at this stage.  If it's a replacement then I'll turn
it into an incremental so I can see what changed, which takes me about 2.15
seconds.

If it had been a large patch or if it had been under test in someone's
tree for a while then a replacement patch would be unwelcome.  But for a
small, fresh patch like this one it's no big deal either way.

