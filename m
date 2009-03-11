Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZCKArS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZCKArS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZCKAqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:46:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46436 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbZCKAqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:46:30 -0400
Message-ID: <49B70993.1040905@zytor.com>
Date: Tue, 10 Mar 2009 17:45:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mark Langsdorf <mark.langsdorf@amd.com>
CC: Andrew Morton <akpm@linux-foundation.org>, eric@lammerts.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][retry 3] Conform L3 Cache Index Disable to Linux standards
References: <200903101541.45739.mark.langsdorf@amd.com>
In-Reply-To: <200903101541.45739.mark.langsdorf@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Langsdorf wrote:
>     Add ABI Documentation entry and fix some /sys directory formating
>     issues with the L3 Cache Index Disable feature for future AMD
>     processors.  Add a check to disable it for family 0x10 models
>     that do not support it yet.

I went to try to apply this patch to -tip, but I *cannot* do so without
a Signed-off-by: line.

(This also means I have done no testing whatsoever.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

