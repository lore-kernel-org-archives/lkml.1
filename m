Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbYAXXsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbYAXXsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYAXXsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:48:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:8222 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYAXXsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:48:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=QwSBKHAAL45+/RWukmbpWODt7MyoA+NLPl9AYuNoYQ//ODkZ03jcfKfinvMWl9tlEHD/t+q/vpXw07X4mEiaps5Oua+TGUkyiLDnGz3KSO1l/cMrtqsLUsiN31fTSw8AJ/ao0UOPzEqdqlJrP+kOu1kUZ42eTa9cjv21CcIi9AY=
Message-ID: <479923AB.5050301@gmail.com>
Date: Fri, 25 Jan 2008 02:47:55 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Heikki Orsila <shdl@zakalwe.fi>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: Re: [PATCH 5/9] bfs: move function prototype to the proper header
 file
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com> <1201213928-18183-6-git-send-email-dmitri.vorobiev@gmail.com> <20080124225031.GC12172@zakalwe.fi> <47991B7C.6000208@gmail.com> <20080124233313.GD12172@zakalwe.fi>
In-Reply-To: <20080124233313.GD12172@zakalwe.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heikki Orsila пишет:
> On Fri, Jan 25, 2008 at 02:13:00AM +0300, Dmitri Vorobiev wrote:
>> Care to explain why?
> 
> Because functions are always external objects in C. I just verified that 
> from K&R.
> 

Yes, I know that :)

The reasons behind me using this keyword were: 1) to keep the code symmetric;
2)-4) as explained elsewhere in this thread.

Anyways, you and Tigran have been convincing enough and the corrected patch
is there.

Thanks,

Dmitri
