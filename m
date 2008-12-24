Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbYLXXYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbYLXXYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 18:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYLXXYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 18:24:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:32571 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbYLXXYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 18:24:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LyZZbmNMA11fpxnj4F0Lwpkz79ysB8yXhf8GG4lno9WsE/VXzj9fdpqM8B3gwZHKow
         swvw78xJLqpF1gdpbJZSkRPZQO35I5ye0RuA92c2VnGzsfYt2WrB6HT7YAAH38K9d5TV
         M55rS8i5+EvSRjBjyVZ48MRmuuNpxg9/l/mJ8=
Message-ID: <4952C4A3.8020805@gmail.com>
Date: Thu, 25 Dec 2008 00:24:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH 0/3] ftrace: updates for tip
References: <20081224042410.746044949@goodmis.org>
In-Reply-To: <20081224042410.746044949@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> This series restructures the output functions of trace.c.
> 
> Events are now registered and maintaining an event output is
> simplified by keeping the output close together.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel

BTW it seems to be more likely on devel than tip/devel ...
