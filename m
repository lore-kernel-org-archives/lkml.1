Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbZFGJCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbZFGJCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 05:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZFGJCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 05:02:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34059 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458AbZFGJCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 05:02:02 -0400
Message-ID: <4A2B8201.8050904@redhat.com>
Date: Sun, 07 Jun 2009 12:01:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: guillaume.thouvenin@ext.bull.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc8 KVM] gcc 3.3 dies at emulate_2op_cl().
References: <200906050539.n555dwAQ077095@www262.sakura.ne.jp>	<4A2B5D0E.20002@redhat.com>	<200906071638.CIC52145.OFOQHLFSMOJVFt@I-love.SAKURA.ne.jp>	<4A2B7A79.4060600@redhat.com> <200906071747.FFJ57396.MSOOQFVHtFOJLF@I-love.SAKURA.ne.jp>
In-Reply-To: <200906071747.FFJ57396.MSOOQFVHtFOJLF@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Avi Kivity wrote:
>   
>> Does the attached patch help?
>>     
> Unfortunately, no.
>
>   

What if you change "rm" in the patch to "m"?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

