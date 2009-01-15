Return-Path: <linux-kernel-owner+w=401wt.eu-S934753AbZAOVHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934753AbZAOVHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933965AbZAOUxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:53:37 -0500
Received: from relay1.sgi.com ([192.48.179.29]:43729 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934088AbZAOUxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:53:35 -0500
Message-ID: <496FA24B.5050306@sgi.com>
Date: Thu, 15 Jan 2009 12:53:31 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: arch_probe_nr_irqs
References: <496AD835.6000509@kernel.org> <20090112091952.GI26750@elte.hu> <20090112092613.GA1822@elte.hu> <496B9FC3.7080306@kernel.org> <496BCD14.3020201@sgi.com> <20090114111949.GO2913@elte.hu> <496E4211.6040503@sgi.com> <20090114201152.GA31581@elte.hu> <496E587E.6010503@sgi.com> <20090115094938.GB5833@elte.hu>
In-Reply-To: <20090115094938.GB5833@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Very cool, thanks!!
>>
>> The one thing I always get hung up on is what args to use with the git 
>> rebase -i command.  Say I want to edit 4a046d1 (which I do ;-), I see it 
>> in my repo with git-log (3rd one down):
> 
> You shouldnt edit 4a046d1 anymore as i already pulled it - you can queue 
> up a fix commit. (Or we can decide to drop the whole tree and re-pull 
> yours - but that is an emergency path not to be taken lightly.)
> 

... rebase description deleted (thanks!)

> 
> Ok?

Yes.

> 
> ( Or if you are sure you can fix the bug via a single pass, you can change 
>   the 'pick' line to 'edit' and do the editing and 'git commit --amend' 
>   right during the rebase. If it's still not perfect it needs another 
>   rebase though and it's easy to mess up rebases. )
> 
> 	Ingo

This all started because you wanted a more descriptive changelog for Yinghai's
probe_nr_irqs() patch.  I was attempting to do this, and is why I sent the
full text to you, in case I couldn't do it (as you explained above).

I'm guessing this subject is now closed?

Thanks,
Mike
