Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbYKCWNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbYKCWNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYKCWNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:13:32 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41748 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752483AbYKCWNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:13:31 -0500
Date: Mon, 3 Nov 2008 17:13:28 -0500
From: Theodore Tso <tytso@mit.edu>
To: Josef Bacik <jbacik@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       rwheeler@redhat.com
Subject: Re: [PATCH] improve jbd fsync batching
Message-ID: <20081103221328.GF18117@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Josef Bacik <jbacik@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, rwheeler@redhat.com
References: <20081028201614.GA21600@unused.rdu.redhat.com> <20081103122729.60582692.akpm@linux-foundation.org> <20081103202442.GA25736@unused.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103202442.GA25736@unused.rdu.redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 03:24:43PM -0500, Josef Bacik wrote:
> I see you already pulled this into -mm, would you like me to repost with the
> same changelog and the patch updated, or just reply to this with the updated
> patch?  Thanks,
> 

Josef,

When you have a moment, any chance you could spin an ext4 version of
the patch, too?  Thanks!!

						- Ted
