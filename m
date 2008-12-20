Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYLTB7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYLTB7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 20:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYLTB67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 20:58:59 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:43009 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbYLTB66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 20:58:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=i9K9N1Ez1sMp6+th7lL3VVSUMi2/m5O7115rwtNKkOz3z7mVO0ok4XchccfB0xhjS2
         M8ymxsIvpcsBMHZlbui4jaXW+fHHqOcCdVDerRxX/Wi1eUiX/zyaWoTDY7UlZFTT0HYl
         dDfny9bOKc47Av40lsv3OieKa9h5KyNo9MuXY=
Message-ID: <494C515E.9040403@gmail.com>
Date: Fri, 19 Dec 2008 21:58:54 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>
Subject: Re: linux-next: Tree for December 17 (Radeon DRM BUG)
References: <20081217232536.0b18f4a7.sfr@canb.auug.org.au>	 <494995D7.6090009@gmail.com> <21d7e9970812172247t3d67e6f0waffa99587e2e024b@mail.gmail.com>
In-Reply-To: <21d7e9970812172247t3d67e6f0waffa99587e2e024b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On Thu, Dec 18, 2008 at 10:14 AM, Kevin Winchester
> <kjwinchester@gmail.com> wrote:
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>>
>> I get the following BUG in the radeon drm code with today's linux-next when
>> I run "startx".  I have not built or tested linux-next in a while, but the
>> problem definitely does not occur in mainline.
> 
> Do you have another X server running or just console?
> 
> can you get a full dmesg with
> 
> echo 1 > /sys/module/drm/parameters/debug
> 

I just tried today's next (20081219) and the problem seems to be fixed.

Thank you,

-- 
Kevin Winchester
