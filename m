Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbXIROKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbXIROKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbXIROKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:10:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbXIROKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:10:08 -0400
To: linux-kernel@vger.kernel.org
Cc: James Pearson <james-p@moving-picture.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 4096 byte limit to /proc/PID/environ ?
References: <E1ITKMm-0002eD-S1@moving-picture.com>
From: Anton Arapov <aarapov@redhat.com>
X-URL: http://people.redhat.com/aarapov
Date: Tue, 18 Sep 2007 16:09:30 +0200
In-Reply-To: <E1ITKMm-0002eD-S1@moving-picture.com> (James Pearson's message of "Thu\,  6 Sep 2007 17\:38\:04 +0100")
Message-ID: <h8k5qoqd45.fsf@pepelac.englab.brq.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi fellas! What we can do for this patch? It looks like ignored at
  all? I want reinitiate this thread because I want to have the
  answer!

  What do you think?

"James Pearson" <james-p@moving-picture.com> writes:
> H. Peter Anvin wrote:
>> Right, also please use use checkpatch.pl.
> OK - how about:
>
> /proc/PID/environ currently truncates at 4096 characters, patch based on 
> the /proc/PID/mem code.
>
> Patch against 2.6.23-rc5
>
> Signed-off-by: James Pearson <james-p@moving-picture.com>
[...patch_skipped...]

-- 
Anton Arapov, <aarapov@redhat.com>
