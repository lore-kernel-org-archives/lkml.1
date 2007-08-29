Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbXH2THm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbXH2THm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758616AbXH2THX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:07:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:56083 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608AbXH2THU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pofUAGxpUxT3Es/xuwTydEPiUUTnKtkS2JYUu1QVedhXsprmPZnza+2JsucRBf7m1vOHkj24Y52ojGJFueBV85KOUOWJCnRM7LRDIwmwDyYHTQso7JmGdqMcXEuzZjbPTfg2f8GJEfRAI+zPCCnG3hlg7fd+6V4sENyv2HfcCFw=
Message-ID: <b6a2187b0708291207tfbf9d6dr43661f15dce33e44@mail.gmail.com>
Date: Thu, 30 Aug 2007 03:07:19 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/4] 2.6.23-rc4: known regressions
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       Markus <lists4me@web.de>, "Antonino A. Daplas" <adaplas@gmail.com>,
       "Jan Dittmer" <jdi@l4x.org>, "Christian Zankel" <chris@zankel.net>,
       linux-alpha@vger.kernel.org, "Stefan Becker" <Stefan.Becker@nokia.com>,
       "Pavel Machek" <pavel@ucw.cz>, "Len Brown" <len.brown@intel.com>
In-Reply-To: <46D5902C.1040905@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46D5902C.1040905@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Subject         : console is messed up after resume from s2ram or switching to console from X
> References      : http://lkml.org/lkml/2007/8/4/6
> Last known good : ?
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Caused-By       : ?
> Handled-By      : H. Peter Anvin <hpa@zytor.com>
>                   Antonino A. Daplas <adaplas@gmail.com>
> Workaround      : "s2ram --force --acpi_sleep 1 --vbe_mode"
> Status          : problem is being debugged

I'm satisfied with the workaround using "s2ram --force --acpi_sleep 1
--vbe_mode", and so is H. Peter Anvin, and he uncovered a different
bug while debugging this.

Please close the case.

Thanks,
Jeff.
