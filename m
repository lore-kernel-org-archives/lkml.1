Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbZAIUF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbZAIUF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZAIUFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:05:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:48176 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbZAIUFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:05:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=odz22BWFP/nuWtTs7YdIogMVAchOCY/Qbzf5uiKoKJyuUj7szB7FdKzORIyk2lz4gr
         KOqUR90oK883v8ueRqCSwlQQmULuoQzWj4ZeN5YoEClmw1iLX5/yGR81mUd86guOy9x9
         KoSj5gG6fS2WdHy/CLZBNVEvI/R12oNcQViV8=
Date: Fri, 9 Jan 2009 22:04:55 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] ftrace: updates for 2.6.29
Message-ID: <20090109220455.0af638c1@daedalus.pq.iki.fi>
In-Reply-To: <20090109002747.240318148@goodmis.org>
References: <20090109002747.240318148@goodmis.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jan 2009 19:27:47 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

Does this mean that from now on all mmiotrace related patches should
be sent to Steven? CC Ingo?
Or should they be split so that kernel/trace stuff is sent to Steven
and arch/x86 stuff to Ingo?

-- 
Pekka Paalanen
http://www.iki.fi/pq/
