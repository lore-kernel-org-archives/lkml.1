Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZAJNDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZAJNDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 08:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZAJNDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 08:03:00 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:31715 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZAJNDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 08:03:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UMu15qYepp9SAKoHgPAeJoZgd7+9a6IZYiOJWiHUQxYMbkRtHVGvnHQJ+1xcwf6TDW
         isiDM8gypQlcPoEUDlcRYyuePB+lmCbjOpD5bssLwzL7+KfTh0LL56XmOZzDh+xOBW7l
         1JYcSxSqJW6GlBVZk2X6nrs0nNO1NCpacv/XE=
Message-ID: <49689C80.3070905@gmail.com>
Date: Sat, 10 Jan 2009 09:02:56 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: venkatesh.pallipadi@intel.com
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 0/6] PAT fixes/cleanup following the pfnmap changes
References: <20090110001308.403550000@intel.com>
In-Reply-To: <20090110001308.403550000@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com wrote:
> Individual patch header has descriptions.
> 

$ git am Patches
Applying: x86 PAT: change track_pfn_vma_new to take pgprot_t pointer param
error: patch failed: mm/memory.c:1604
error: mm/memory.c: patch does not apply
Patch failed at 0001.
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".


These do not apply for me to latest Linus git, which is the tree where I experienced the problem.  Is there some way to fuzz them to get them to apply?

-- 
Kevin Winchester

