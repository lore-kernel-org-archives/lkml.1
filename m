Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZKILgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZKILgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 06:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbZKILgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 06:36:44 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:64790 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZKILgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 06:36:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sDUJtzhK4VnQ6UO3hRWq7V14CclNuV1bU+0IbJW9BzjlXYfQycX2qEnnKstzLL61OA
         Nuj2rlzYnNnbmoHdQxXpccKG9ErYU9oEQpMUaN/E0ev34nxbZerzReQAiEfWiEP9pAav
         +0sCs1LemkuCaBHvt3i5fYUZiL8w2yTGCLauw=
Date: Mon, 9 Nov 2009 12:36:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
Subject: Re: [PATCH -v6 08/13] tracing: add IRQENTRY_EXIT section for MIPS
Message-ID: <20091109113647.GA5206@nowhere>
References: <cover.1256569489.git.wuzhangjin@gmail.com> <f746f813531a16bd650f9290787c66cbc0cdc34d.1256569489.git.wuzhangjin@gmail.com> <20091109022640.GC13153@nowhere> <1257737468.3451.9.camel@falcon.domain.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257737468.3451.9.camel@falcon.domain.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 11:31:08AM +0800, Wu Zhangjin wrote:
> Who should I resend this patchset to? you or Steven? If this patchset
> are okay, I will rebase it on the latest tracing/core branch of -tip and
> send the latest version out, and hope you can apply it, otherwise, I
> need to rebase it to the future mainline versions again and again ;) and
> at least, I have tested all of them and their combinations on YeeLoong
> netbook, they work well. of course, more testing report from the other
> MIPS developers are welcome ;)
> 
> Regards,
> 	Wu Zhangjin


You can keep the current Cc list so that we are all uptodate with the
latest state. I don't think you need to rebase against latest tracing/core
as there doesn't seem to be conflicatble changes inside added lately.
The person who is likely to apply it is Steven as he can test it :)

Thanks.

