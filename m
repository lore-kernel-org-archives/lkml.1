Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbYBRDPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbYBRDPg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 22:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbYBRDP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 22:15:29 -0500
Received: from relay1.sgi.com ([192.48.171.29]:52680 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753681AbYBRDP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 22:15:28 -0500
Date: Sun, 17 Feb 2008 21:15:25 -0600
From: Paul Jackson <pj@sgi.com>
To: Neil Brown <neilb@suse.de>
Cc: torvalds@linux-foundation.org, corbet@lwn.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Documentation/patch-tags, one more time
Message-Id: <20080217211525.09ae860f.pj@sgi.com>
In-Reply-To: <18360.62530.142639.141506@notabene.brown>
References: <9525.1202489479@vena.lwn.net>
	<alpine.LFD.1.00.0802080959130.2896@woody.linux-foundation.org>
	<18360.62530.142639.141506@notabene.brown>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil responding to Linus:
> > "From:" is not a tag. It's a special marker at the *top*
>
> You may be right, but when I email patches to akpm

Linus wasn't saying you don't need a 'From:' line in this case (as the
*top* line of patches you didn't author).  He's saying it's not an
instance of the type "tag" line, such as the "Signed-off-by:" line that
go after the patch explanation.  The "From:" line is a different kind
of line, with different rules and position.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
