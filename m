Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbZIPEx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbZIPEx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZIPEx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:53:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58668 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZIPEx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:53:26 -0400
Message-ID: <4AB06EE3.4010509@zytor.com>
Date: Tue, 15 Sep 2009 21:51:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] edac: need to export cpu_llc_id
References: <20090916093935.6bc2c91f.sfr@canb.auug.org.au> <20090916044151.GB5767@aftab>
In-Reply-To: <20090916044151.GB5767@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2009 09:41 PM, Borislav Petkov wrote:
> 
> proper fix is at http://marc.info/?l=linux-kernel&m=125302459621925
> 
> we still have to figure out who's gonna pick it up. Ingo?
> 

This was from a tree you pushed straight to Linus, so it's probably
better you push it directly.

You can add:

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

