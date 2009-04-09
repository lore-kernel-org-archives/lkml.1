Return-Path: <linux-kernel-owner+w=401wt.eu-S1761324AbZDIHl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761324AbZDIHl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 03:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758488AbZDIHlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 03:41:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36154 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbZDIHlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 03:41:08 -0400
Message-ID: <49DDA6BB.6080909@redhat.com>
Date: Thu, 09 Apr 2009 10:41:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] disable interrupt shadow state for emulated instruction
References: <1239213452-5966-1-git-send-email-glommer@redhat.com> <49DCE9E5.8020703@zytor.com> <20090408183110.GD25323@poweredge.glommer> <49DCED9A.8030108@zytor.com>
In-Reply-To: <49DCED9A.8030108@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Glauber Costa wrote:
>> mov ss is a non-issue, since it is executed natively.
>
> In real mode?
>

Yes.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

