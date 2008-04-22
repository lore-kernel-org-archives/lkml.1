Return-Path: <linux-kernel-owner+w=401wt.eu-S1762241AbYDVTSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762241AbYDVTSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbYDVTSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:18:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:52688 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbYDVTSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Fe/yNJSDAS593U9e6WFUkJhVskPStHcPRqlcHroPSmE3jRRIuEMsNnnkyBqE2VAn8Ytsf4CUafAJPddPWE/gc35lpc0dxydV8VyIeiji4uEsBS+/6bJER4DyGizSH97ytdmoxq5btpUaJi4qm76F8ikN5/b5CGtJ6oJUmdS5Lu4=
Message-ID: <480E3A00.7060401@gmail.com>
Date: Tue, 22 Apr 2008 23:18:24 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: random clean-ups
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com> <20080421122504.GF6788@elte.hu> <90edad820804210541h26c8e66dh70895f32e4b4038d@mail.gmail.com> <20080422140203.GB24966@elte.hu>
In-Reply-To: <20080422140203.GB24966@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar пишет:
> * Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
> 
>>> thanks Dmitri, applied #1/#2/#4, as per the discussion.
>> Hi Ingo,
>>
>> This should be #1, #3 and #4. The NexGen patch, which was #2 in the 
>> original series, have been replaced by a bigger patch that kills 
>> NexGen altogether. Plese check, if you have time for that.
> 
> yeah, i did the right thing and described the wrong selection :) You can 
> check the end result via:
> 
>   http://people.redhat.com/mingo/x86.git/README

... which indicates that #4 is still not there, which is a pity, since
the #4 patch gave me a more-than-negligible binary shrinkage for the case
CONFIG_SYSFS=n :)

Dmitri

> 
> 	Ingo
> 

