Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYKARzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYKARzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 13:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYKARzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 13:55:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:33970 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbYKARzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 13:55:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a7VUq01OSFmxkCMhohJcpw8NsnOPRSq8ByDsO3CJMyzcbn6CRn8X1TNHvpvbFxe+cg
         bJlvif2XAZKHbb5FXE9fwnGvkbvFkg077qzEWB/B4AsX/IUS9n5E90B1IGeIHcs0Axdz
         9YJcGzY3PuUofe+wo+xzIoKO+6wvMypEtZvU0=
Message-ID: <d9def9db0811011055x7d75b705oa1facb09834bd1c5@mail.gmail.com>
Date: Sat, 1 Nov 2008 18:55:36 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
Cc: "Devin Heitmueller" <devin.heitmueller@gmail.com>,
       "Hans Verkuil" <hverkuil@xs4all.nl>, v4l <video4linux-list@redhat.com>,
       linux-dvb@linuxtv.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, "Greg KH" <greg@kroah.com>,
       mchehab@infradead.org
In-Reply-To: <84144f020811010929q579bebd7p8760d34631df2fd4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811011505.51716.hverkuil@xs4all.nl>
	 <412bdbff0811010846h2edd63bfn44536e8a1c72d17f@mail.gmail.com>
	 <84144f020811010908h1220d209j799edca3eb772fd@mail.gmail.com>
	 <412bdbff0811010919v3b336939qf94df1162ecbbb28@mail.gmail.com>
	 <84144f020811010929q579bebd7p8760d34631df2fd4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2008 at 5:29 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Sat, Nov 1, 2008 at 6:19 PM, Devin Heitmueller
> <devin.heitmueller@gmail.com> wrote:
>> The reality is that from a technical standpoint I really want Markus
>> to be the maintainer.  He knows more about the devices than anyone,
>> works for the vendor, and has access to all the datasheets.  That
>> said, I don't want a situation where he is the *only* one who can do
>> work on the codebase because it is poorly commented and structured in
>> a way where only he can understand why it works the way it does.
>> Also, I believe certain design decisions should be made as a result of
>> consensus with the other maintainers, taking into consideration
>> consistency across drivers.
>
> I can understand that you want him to be the maintainer. But so far he
> hasn't really shown to be interested in doing that. It's just bit sad
> that the we don't have a proper driver given that the code exists and
> that there's a person who's willing to do the work to get it merged...
>

There's alot discussion and I haven't followed it yet although, the
best way to go
seen from my side is to take the em28xx-new code and merge the usable kernelcode
into that one (note that only ~10% of the devices in the kernel em28xx
driver are actually
tested).

I read about the License, I can say this is no issue overall, all of
the code is available under GPL,
and some of it is also under BSD license.

I need to catch up the other mails before continuing...

Markus
