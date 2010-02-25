Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313Ab0BYS3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:29:38 -0500
Received: from smtp-out.google.com ([216.239.33.17]:19384 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250Ab0BYS3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:29:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=v8dR00NjHrVu1gXcqCmGcNHMxqfmfQv5WCXC0aIQqf1okHcLLEib1M+zuqsENP99j
	gNo1A/fb0VFT6P6eWALZQ==
MIME-Version: 1.0
In-Reply-To: <1265295302.24455.2265.camel@laptop>
References: <4b674594.0a04d00a.6005.2567@mx.google.com>
	 <1265295302.24455.2265.camel@laptop>
Date: Thu, 25 Feb 2010 19:29:32 +0100
Message-ID: <bd4cb8901002251029p2831f892p739b6109f28da563@mail.gmail.com>
Subject: Re: [PATCH] perf_events: AMD event scheduling (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Was the AMD Northbridge patch ever applied to tip?
I don't see it in 2.6.33-rc8-tip+.
