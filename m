Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbZKLWQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbZKLWQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbZKLWQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:16:55 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35098 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbZKLWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:16:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iYziItFVqPfxilaRif/hk4ObThGe1T9OxpmJXy1RGPI3QoMrjoJLGXMnwdM/7vFF75
         QNzAkbtgt+KzbSLdRam6ktBx1eRADCRee+K8wkH3qEWpEHgwtP1qfmOa2FrBhFnKxDH7
         NqL+18A2cFnFC0Z3r7/kyISGB3mfV6cqf2Tyk=
MIME-Version: 1.0
In-Reply-To: <20091112171934.584037000@alcatraz.americas.sgi.com>
References: <20091112171934.584037000@alcatraz.americas.sgi.com>
Date: Thu, 12 Nov 2009 14:16:59 -0800
Message-ID: <86802c440911121416i2185b992u915efd01b745c1b2@mail.gmail.com>
Subject: Re: [PATCH 0/7] Limit console output by suppressing repetitious 
	messages
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 9:19 AM, Mike Travis <travis@sgi.com> wrote:
>
> Second version...

what is the boot time that you can spare your this patchset?

YH
