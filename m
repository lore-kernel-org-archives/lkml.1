Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbXEaQ3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbXEaQ3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXEaQ3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:29:06 -0400
Received: from dsl-mtryl-66-18-218-115-cgy.nucleus.com ([66.18.218.115]:58617
	"HELO schaus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752469AbXEaQ3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:29:05 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2007 12:29:05 EDT
Message-ID: <465EF63D.20607@schaus.ca>
Date: Thu, 31 May 2007 10:22:21 -0600
From: Cameron Schaus <cam@schaus.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Gary Martin <gm4rtin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel Oops on 2.6.18-1.2869.fc6 is this a bug?
References: <43806ba60705030524g2a8b0e54m2dda6f52615eba77@mail.gmail.com> <6bffcb0e0705030536s61d42ec0x27a4b54ddef234a3@mail.gmail.com>
In-Reply-To: <6bffcb0e0705030536s61d42ec0x27a4b54ddef234a3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> You need to upgrade the kernel "yum upgrade kernel.i686"
>
> If the problem still appears, fill bug report in RedHat bugzilla
> https://bugzilla.redhat.com/bugzilla/index.cgi
I am seeing this problem in the FC5 2.6.20-1-2316 kernel, and I have not 
seen a new kernel show up in the updates yet.

What exactly is the issue?  I would like to know so that I can patch in 
the fix that went into the FC6 kernel into my FC5 kernel.

Thanks,
Cam

