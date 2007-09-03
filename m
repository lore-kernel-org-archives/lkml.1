Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbXICMgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbXICMgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 08:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXICMgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 08:36:37 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:4576 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbXICMgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 08:36:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=REltVxAKtworbzomT0vSl5ZHlyUI+amvOCSp0cAGgtxMWJ5jzO67PfuepfSJoW1lY1gYJOJ2q7CdcamM96yECyC6KEgz7ScPmSg7WTmSRjvfE4rVRCagWMaEwb1mmKgAEWeCOzzh9eYnaZuGYXFH3+eqnKUy2IhccSI7f47uRcE=
Message-ID: <b6a2187b0709030536w3e40f12bk4d25b6eb954d22b6@mail.gmail.com>
Date: Mon, 3 Sep 2007 20:36:32 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [2/4] 2.6.23-rc5: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       Markus <lists4me@web.de>, "Antonino A. Daplas" <adaplas@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "Len Brown" <lenb@kernel.org>,
       dth <dth@dth.net>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>,
       "Andrew Clayton" <andrew@digital-domain.net>,
       "Peter Kovar" <peter.kovar@gmail.com>
In-Reply-To: <46DBDD8B.7040706@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46DBD982.3080102@googlemail.com> <46DBDD8B.7040706@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Subject         : console is messed up after resume from s2ram or switching to console from X
> References      : http://lkml.org/lkml/2007/8/4/6
> Last known good : ?
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Caused-By       : ?
> Handled-By      : H. Peter Anvin <hpa@zytor.com>
>                   Antonino A. Daplas <adaplas@gmail.com>
> Workaround      : "s2ram --force --acpi_sleep 1 --vbe_mode"
> Status          : problem is being debugged

Michal,

Can you please close this case. I'm using the workaround and satisfied with it.

Thanks,
Jeff.
