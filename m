Return-Path: <linux-kernel-owner+w=401wt.eu-S934215AbYBHTCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbYBHTCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934892AbYBHTBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:01:32 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55371 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934864AbYBHTB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:01:28 -0500
Date: Fri, 8 Feb 2008 13:01:26 -0600
From: Paul Jackson <pj@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Documentation/patch-tags, one more time
Message-Id: <20080208130126.e05be25d.pj@sgi.com>
In-Reply-To: <alpine.LFD.1.00.0802080959130.2896@woody.linux-foundation.org>
References: <9525.1202489479@vena.lwn.net>
	<alpine.LFD.1.00.0802080959130.2896@woody.linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus wrote:
> "From:" is not a tag. It's a special marker at the *top* (and _only_ the top)

So ... instead of listing "From:" as just another tag, I'd think it would
work if this one was listed in a separate section, perhaps at the end of this
Documentation/patch-tags document, such as:


From:	In addition to the above tags, one can also specify the original author
	of the change, who will end up as the commit author, with a special marker
    	at the top (very first line) of the patch, with a "From:" line.  See further
	Documentation/SubmittingPatches for usage of this "From:" line.


Question -- should this documentation of patch-tags be in its own file,
or added to Documentation/SubmittingPatches.  If it remains in its own
file, then perhaps Documentation/SubmittingPatches should have a reference
to Documentation/patch-tags added.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
