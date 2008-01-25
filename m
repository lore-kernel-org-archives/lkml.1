Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbYAYKHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbYAYKHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYAYKGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:06:53 -0500
Received: from ro-out-1112.google.com ([72.14.202.182]:39326 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbYAYKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:06:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=nNChWcB9vIFXu7KzBfi3ZpmSfoKCq+Z3zbXYxzubEkzkhqfOTvntdDBPDApOhusJeYpXjHgsSGGsVfyN0J70GHvWmw0XkKBMGR4bu8p4P1ZsLhFOgcyY3xpInekzMIhnetSygaXz0CnkAlekxEiYveWvicPjZ4o89gDkMgwwR58=
Date: Fri, 25 Jan 2008 18:04:52 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       mingo@redhat.com
Subject: Re: Incorrect filename comments in arch/x86/boot
Message-ID: <20080125100452.GH4726@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080122193915.GA3926@elf.ucw.cz> <47964FFC.9040601@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47964FFC.9040601@zytor.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 12:20:12PM -0800, H. Peter Anvin wrote:
>Pavel Machek wrote:
>>Hi!
>>
>>Not sure if this is worth fixing, or if I should just delete those
>>comments...? (Or does someone want to do that? ;-). 
>>									Pavel
>
>I'll take care of it.
>

Hmm, arch/i386/boot/ is an empty dir. Why not remove it?
Only used to put bzImage? Why not choose another dir?
Maybe arch/x86/boot/, I think. ;)


