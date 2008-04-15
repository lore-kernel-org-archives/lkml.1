Return-Path: <linux-kernel-owner+w=401wt.eu-S1763994AbYDODL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763994AbYDODL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 23:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761580AbYDODLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 23:11:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:60422 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761574AbYDODLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 23:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VJMYTcxsS3+mCXgULGXTrHBXwwUl2kkZhk7k2LFDL4L6uZsoDRn1vgAySniOl0NLzHL57RdpMydPXVAhhXxhShXbQBsnGA/sbBMwr4mWS4YGO4q5g1eWx2F1cZOzfSnuotAOFwXGO32adWEWAb0ZVwfPqSG0vry906cJAdmDTVw=
Message-ID: <48041CC1.1030909@gmail.com>
Date: Tue, 15 Apr 2008 12:10:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: libata errors with smartctl on 2.6.24, WD3200AAKS and nVidia
 AHCI
References: <200804092130.07149.tvrtko@ursulin.net> <480179D3.8070707@gmail.com> <200804130834.14257.tvrtko@ursulin.net>
In-Reply-To: <200804130834.14257.tvrtko@ursulin.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko A. Ursulin wrote:
> On Sunday 13 April 2008 04:11:15 Tejun Heo wrote:
>> Is auto spindown configured for the drive?
> 
> I don't think so - it's a 3.5" drive with no special PM features - but how to 
> tell?

Hmm... Can you please post the result of "smartctl --version" and 
"smartctl -a > out 2>&1" and dmesg after the smartctl command?

Thanks.

-- 
tejun
