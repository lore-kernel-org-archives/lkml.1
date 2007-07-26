Return-Path: <linux-kernel-owner+w=401wt.eu-S1763428AbXGZHvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763428AbXGZHvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 03:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757218AbXGZHvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 03:51:10 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:46636 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495AbXGZHvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 03:51:10 -0400
Message-ID: <46A851F8.7080006@gmail.com>
Date: Thu, 26 Jul 2007 09:49:12 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Andika Triwidada <andika@gmail.com>
CC: Robert Deaton <false.hopes@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org
Subject: Re: updatedb
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com>	 <46A773EA.5030103@gmail.com>	 <a491f91d0707251015x75404d9fld7b3382f69112028@mail.gmail.com>	 <46A81C39.4050009@gmail.com> <7e0bae390707252323k2552c701x5673c55ff2cf119e@mail.gmail.com>
In-Reply-To: <7e0bae390707252323k2552c701x5673c55ff2cf119e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2007 08:23 AM, Andika Triwidada wrote:

> On 7/26/07, Rene Herman <rene.herman@gmail.com> wrote:

>> RAM intensive? If I run updatedb here, it never grows itself beyond 2M.
>> Yes, two. I'm certainly willing to accept that me and my systems are 
>> possibly not the reference but assuming I'm _very_ special hasn't done
>> much for me either in the past.
> 
> Might be insignificant, but updatedb calls find (~2M) and sort (~26M).

It does? My updatedb certainly doesn't seem to (slackware 12.0). It's using 
"Secure Locate". Different distributions using different versions of locate 
it seems?

Rene.
