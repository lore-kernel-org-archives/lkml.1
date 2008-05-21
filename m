Return-Path: <linux-kernel-owner+w=401wt.eu-S937027AbYEUTzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937027AbYEUTzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763192AbYEUTyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:54:54 -0400
Received: from mail2.shareable.org ([80.68.89.115]:49465 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575AbYEUTyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:54:53 -0400
Date: Wed, 21 May 2008 20:54:42 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
       Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-ID: <20080521195442.GA27231@shareable.org>
References: <482DDA56.6000301@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com> <200805191439.36577.chris.mason@oracle.com> <20080521112224.GD5028@ucw.cz> <20080521110324.668048e0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521110324.668048e0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> If we do make this change I think it should be accompanied by noisy
> printks so that as many people as possible know about the decision
> which we just made for them.

I favour saying barrier=1 in /proc/mounts, even though it will become
the new default.  At least for a while.

-- Jamie
