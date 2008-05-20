Return-Path: <linux-kernel-owner+w=401wt.eu-S933147AbYETO7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbYETO7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbYETO65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:58:57 -0400
Received: from mail2.shareable.org ([80.68.89.115]:44431 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbYETO64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:58:56 -0400
Date: Tue, 20 May 2008 15:58:13 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-ID: <20080520145813.GE16676@shareable.org>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <482DDA56.6000301@redhat.com> <4830E60A.2010809@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805191316.27551.chris.mason@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:

> Everyone thinks the barriers are slow because we also think running
> without barriers is mostly safe.

+1.  There really hasn't been much effort at optimising barriers.

> Making them faster in general may be possible, but they are somewhat
> pushed off to the side right now because so few people are running them.

+1 too.

-- Jamie
