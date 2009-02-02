Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZBBKZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZBBKZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 05:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbZBBKZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 05:25:28 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:40640 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZBBKZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 05:25:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BRaLfqa5sDdk3h17tT4nkHANSktyJHe2LY2x+m6hoztYeYDSfAybGX+kAqyXij4Q9u
         nPksvli7/euj8jhdyyXMnE9To3/Rjr4jifDWprkwLu2r8OH4R5eIxoBKbJkAn8fGo9OR
         J8I7Ne1CiBfEJ+kbB6vqBKQuFZ3ItFvwS3y68=
MIME-Version: 1.0
In-Reply-To: <20090202101735.GA12757@barrios-desktop>
References: <20090202101735.GA12757@barrios-desktop>
Date: Mon, 2 Feb 2009 19:25:27 +0900
Message-ID: <28c262360902020225w6419089ft2dda30da9dfb32a9@mail.gmail.com>
Subject: Re: [BUG??] Deadlock between kswapd and sys_inotify_add_watch(lockdep 
	report)
From: MinChan Kim <minchan.kim@gmail.com>
To: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>, linux mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But, I am not sure whether it's real bug or not.
I always suffer from reading lockdep report's result. :(
It would be better to have a document about lockdep report analysis.
-- 
Kinds regards,
MinChan Kim
