Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZIMOFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZIMOFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 10:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZIMOFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 10:05:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:14721 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbZIMOFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 10:05:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XCEvc21X4Ui62eOElADUwcGrTn8x+DebdBtNX8D7x/f8gsL9dmO4IiDnAGBx5iuaMp
         okTdKgjUw4P/YujCbAQCjUrJPS28pTpzvpup3gfiq9myAQLGpdhxlWyzE/qsf/a6LorO
         AE2ze+qutG0ZFKzw2zWumr6Hfqe6MrsEGumQU=
MIME-Version: 1.0
In-Reply-To: <4A21EA8E.6060507@redhat.com>
References: <20090515075229.11346.6710.sendpatchset@localhost.localdomain>
	 <20090528004100.3716e00d.akpm@linux-foundation.org>
	 <4A21EA8E.6060507@redhat.com>
Date: Sun, 13 Sep 2009 17:05:18 +0300
Message-ID: <94a0d4530909130705o6886d496o670d1b978a9fc75f@mail.gmail.com>
Subject: Re: [Patch] kbuild: fix a compile warning
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 5:25 AM, Amerigo Wang <amwang@redhat.com> wrote:
> Andrew Morton wrote:
>>
>> On Fri, 15 May 2009 03:51:18 -0400 Amerigo Wang <amwang@redhat.com> wrote:
>>
>>
>>>
>>> I got this warning:
>>>
>>
>> With which gcc version?
>>
>
> gcc version 4.4.0 (GCC)

I'm also getting this warning on 4.4.1. Can we merge this patch?

-- 
Felipe Contreras
