Return-Path: <linux-kernel-owner+w=401wt.eu-S1762676AbXF0RdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762676AbXF0RdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbXF0RdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:33:18 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:39060 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872AbXF0RdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:33:18 -0400
Message-ID: <46829E82.6080804@gmail.com>
Date: Wed, 27 Jun 2007 19:29:38 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Andreas Hartmetz <ahartmetz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <200706271825.17459.ahartmetz@gmail.com>
In-Reply-To: <200706271825.17459.ahartmetz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2007 06:25 PM, Andreas Hartmetz wrote:

> I don't like random applications blocking my sound card.

So don't use random applications.

> You are concerned about your precious audio quality? Me too. Most people, 
> however, are using god-awful plastic speakers for twenty euros and shitty 
> onboard sound chips. Sad but true.

Exactly, which is why mixing has been default for some time now for most 
cards. Are you only ranting about how it should've been earlier?

> ALSA appeared in 1999, KDE 2 with aRtsd (another catastrophic failure of 
> technology) was released in october 2000.

http://www.arts-project.org/gen/newsarchive/news_1998.html

>>  That sounds like a minor glitch that should be easily remedied if you
>>  file a proper bug report. Have you tried?
>>
> No, I kinda gave up on ALSA after reading its API (rather "functions 
> that happen to be exported") documentation and kinda hoped it would go away 
> ASAP.

You give up reporting small hardware problems that bother you because the 
application developer documentation for something is not in great shape? 
What an odd thing to do. And what a shame that this thread apparently was 
unable to outlive it's originator troll and turn useful...

[ ... ]

> hacking (i.e. more features faster). Latency is an issue? - Well you can't 
> play sound without userspace creating it so you're not adding any new 
> problems.

Capture.

Rene.

