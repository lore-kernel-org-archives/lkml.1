Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbZBLTVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbZBLTVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 14:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758086AbZBLTVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 14:21:07 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:45939 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757864AbZBLTVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 14:21:05 -0500
Date: Thu, 12 Feb 2009 14:21:04 -0500
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Junio C Hamano <gitster@pobox.com>,
       L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: git-send-email
Message-ID: <20090212192104.GD15809@csclub.uwaterloo.ca>
References: <1234451714.10603.22.camel@laptop> <200902121825.35021.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902121825.35021.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 06:25:34PM +0100, Ingo Oeser wrote:
> No, they are great, if you like to skip over a topic, you are not
> interested in at all!
> 
> If you don't like it, just switch off thread in your mailer and
> don't force this on everybody else!

Actually if (as apparently many people seem to manage to do) you have a
single starting email, with all the patches as replies to that first
email, it looks a lot better, and is much easier to follow.

Seperate threads would be bad.

foobar patch 0 (usually a summary/overview)
+-foobar patch 1
+-foobar patch 2
+-foobar patch 3
+-foobar patch 4
+-foobar patch 5

is much nicer than

foobar patch 0
+-foobar patch 1
  +-foobar patch 2
    +-foobar patch 3
      +-foobar patch 4
        +-foobar patch 5

which seems to be what git does itself.

-- 
Len Sorensen
