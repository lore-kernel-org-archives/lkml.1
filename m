Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbXGZKTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbXGZKTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXGZKTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:19:30 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:39171 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbXGZKTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:19:30 -0400
Message-ID: <46A874B8.7000407@gmail.com>
Date: Thu, 26 Jul 2007 12:17:28 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Masoud Sharbiani <masouds@google.com>, Kirill Korotaev <dev@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: i386-show-unhandled-signals-v3
References: <20070718154759.GA26425@google.com>	<4517d1380707251407v178068baxcc76a86f8337cc27@mail.gmail.com>	<20070725162528.7d485ff8.akpm@linux-foundation.org>	<200707261146.23886.ak@suse.de> <20070726111652.56467031@the-village.bc.nu>
In-Reply-To: <20070726111652.56467031@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2007 12:16 PM, Alan Cox wrote:

> On Thu, 26 Jul 2007 11:46:23 +0200
> Andi Kleen <ak@suse.de> wrote:
> 
>>> Look: if there's a way in which an unprivileged user can trigger a printk
>>> we fix it, end of story. 
>> I'm firmly against disabling it on x86-64 by default. The printks are extremly
>> useful and have found many bugs in the past.
> 
> Then add the rate limiting by default.

The messages were rate limited -- Andrew said they couldn't be on default even 
rate limited.

Rene.
