Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbYIGIDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbYIGIDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 04:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYIGIDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 04:03:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:39079 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYIGID3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 04:03:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pClA8HJEpZXGJmDfrWLb+cI1a+5fe/eKwfHVBQ6RNy5dcGXeB03Pkgelqmk4LWLamf
         9nmJ+tPRmd0DybrhwXrCUq+1MDll5rHJroJ7zmIw8DokTUT/fdj8VhgR+KxjbHHKjpwT
         E0GhSN81jl0M2m+WUfkkw7htHpF2v0KpNH8g0=
Message-ID: <86802c440809070103g44ef6e57kb85ad9a7a7dd30ad@mail.gmail.com>
Date: Sun, 7 Sep 2008 01:03:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alain Knaff" <alain@knaff.lu>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
Cc: "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48C38540.4050201@knaff.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>
	 <48C34803.60006@zytor.com> <48C38540.4050201@knaff.lu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2008 at 12:39 AM, Alain Knaff <alain@knaff.lu> wrote:
> H. Peter Anvin wrote:
>> Alain Knaff wrote:
>>>
>>> This version applies to kernel 2.6.26.3
>>>
>>
>> Could you produce a version against the -tip tree, either the master
>> branch or the x86/setup branch?
>>
>>     -hpa
>
> Thanks for the note... but where/how can I download the -tip tree from?

http://people.redhat.com/mingo/tip.git/readme.txt

YH
