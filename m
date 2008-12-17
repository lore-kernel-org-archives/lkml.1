Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755829AbYLQFll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYLQFll (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 00:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYLQFlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 00:41:31 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:57766 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751136AbYLQFla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 00:41:30 -0500
Date: Wed, 17 Dec 2008 00:41:27 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jeff Arnold <jbarnold@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Tim Abbott <tabbott@mit.edu>, Anders Kaseorg <andersk@mit.edu>,
        Waseem Daher <wdaher@mit.edu>, Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH 7/7] Ksplice: Support updating x86-32 and x86-64
Message-ID: <20081217054127.GI10590@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Arnold <jbarnold@MIT.EDU>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Denys Vlasenko <vda.linux@googlemail.com>,
	Tim Abbott <tabbott@mit.edu>, Anders Kaseorg <andersk@mit.edu>,
	Waseem Daher <wdaher@mit.edu>,
	Nikanth Karthikesan <knikanth@suse.de>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <1228521840-3886-2-git-send-email-jbarnold@mit.edu> <1228521840-3886-3-git-send-email-jbarnold@mit.edu> <1228521840-3886-4-git-send-email-jbarnold@mit.edu> <1228521840-3886-5-git-send-email-jbarnold@mit.edu> <1228521840-3886-6-git-send-email-jbarnold@mit.edu> <1228521840-3886-7-git-send-email-jbarnold@mit.edu> <1228521840-3886-8-git-send-email-jbarnold@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228521840-3886-8-git-send-email-jbarnold@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One thing that would be *really* helpful is some function-level
documentation.  What various functions do, what locks they assume are
held, what locks they take/release, etc.  kernel/ksplice.c is *long*
some signposts would definitely make it easier for folks to understand
what is going on.

Regards,

						- Ted
