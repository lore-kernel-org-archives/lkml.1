Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab0CLI7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:59:31 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45534 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab0CLI73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:59:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CJQNE+O/2b8taqcxpFRNRiWlpdF53HP3Ok2XgYBZFlRcRy3+b7G0dG51tBDirDKcHF
         Yj4fDqp3Gop/9KZazwAcNkG+xb+RvTHH83nZsXbLxe8CsOacJZm2wRu78LaC6Tr5B8AC
         dGED6dNqoH+KX6XPOiMK1wEAGs6/7Cgm2UIhc=
Message-ID: <4B9A026D.1030806@gmail.com>
Date: Fri, 12 Mar 2010 09:59:25 +0100
From: Till Kamppeter <till.kamppeter@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100222 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       lsb-discuss@lists.linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux wireless GSoC 2010 project ideas
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com> <20100128231545.GH18683@nowhere> <43e72e891001281523s56707279x896ab059e6d4e530@mail.gmail.com> <4B62231F.5080104@gmail.com> <20100309224347.GD5058@nowhere>
In-Reply-To: <20100309224347.GD5058@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can someone post this project idea on the ideas list today (marking that 
it comes from a student). This could support our application as 
mentoring organization.

    Till

On 03/09/2010 11:43 PM, Frederic Weisbecker wrote:
> On Fri, Jan 29, 2010 at 12:51:59AM +0100, Till Kamppeter wrote:
>> No problem for students to suggest topics. We are not restricted to
>> wireless in terms of kernel. We support kernel projects in general.
>>
>> Please give your suggestion as answer to this e-mail, doing "Reply to
>> all", as I am not a kernel export, the other participants of this thread
>> should have a look at the student's project ideas and help finding
>> mentors.
>>
>>     Till
>
>
>
> Ok, I hope it's not too late.
> Here is one subject that I would like to apply for:
>
>
> = Improving tracing in perf events / ftrace =
>
>
> Using trace events under perf events is still a young feature
> and needs various improvements.
>
> - Syscall events can carry only raw values and addresses.
> We need to make them "aware" of strings and structures contents
> from userspace.
>
> - Make function / function graph tracers usable by perf
>
> - Optimize tracing fast-path
>
> - Improve perf tools to better handle trace events scalability
>
> - Provide new perf tools that exploit trace events (scheduler
>    migration analysis, etc...)
>
> - Implement a per context excluding (eg: exclude irqs, exclude functions, etc...)
>
> - There are always things to do there.
>
>
> Of course, each of these elements require a lot of work,
> so not all of them can be done in two months, and some
> of them can be started already before the summer.
>
>

