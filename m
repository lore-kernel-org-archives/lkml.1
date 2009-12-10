Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbZLJNrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbZLJNrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759117AbZLJNrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:47:13 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:61839 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860AbZLJNrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:47:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=GDmjVtG5Zb5bGuEgkRDSjJGhI8ke5vgTm3wHap56EiRvwt8CyazpKVqa2GGqeZfbcL
         ij6O5b7ZhyLo0b3tafkzbJmzE+E2vfGCGGGmCT+wWQEueUrrWxwpppj7qzYHNjWbiieF
         ZxFC5ICbYVh55Gi6L3azMbUq1WM0DRpbOONQA=
MIME-Version: 1.0
In-Reply-To: <20091210132744.GB25664@bicker>
References: <4B192D08.9080608@gmail.com>
	 <9b2b86520912080205x478b47eek2377dacdbe44a522@mail.gmail.com>
	 <4B1E85A9.3030005@gmail.com>
	 <9b2b86520912090517l458bc21cobbb138d460e11f53@mail.gmail.com>
	 <20091210132744.GB25664@bicker>
Date: Thu, 10 Dec 2009 13:47:16 +0000
Message-ID: <9b2b86520912100547v7feb34dbj8e94e6bcd3a0a49e@mail.gmail.com>
Subject: Re: Toshiba Bluetooth enabler (v2) (was: Re: [PATCH] Toshiba 
	Bluetooth enabler (rfkill))
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Dan Carpenter <error27@gmail.com>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Jes Sorensen <jes.sorensen@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/09, Dan Carpenter <error27@gmail.com> wrote:
> On Wed, Dec 09, 2009 at 01:17:48PM +0000, Alan Jenkins wrote:
>> On 12/8/09, Jes Sorensen <jes.sorensen@gmail.com> wrote:
>> > On 12/08/2009 11:05 AM, Alan Jenkins wrote:
>> >> Cool.  This must be the shortest ACPI driver :-).
>> >
>> > Hi Alan,
>> >
>> > Here's an updated version that addresses most of your comments.
>>
>> Hi again
>>
>> >> Try to send patches inline if possible, it makes them easier to review.
>> >
>> > Not possible with Thunderbug, sorry.
>>
>> I'm guessing you mean Thunderbird.  I manage in Thunderbird by
>>
>> a) composing in HTML
>> b) selecting "preformat" from the drop-down menu (the default is "body
>> text"
>> c) copy+pasting the patch
>>
>> I seem to have word wrap disabled as well (under
>> prefs->composition->general), but I think "Preformat" is enough on its
>> own.
>>
>
> There is a Thunderbird section under Documentation/email-clients.txt

Yes.  I found it and then didn't mention it.

"
- Under account settings, composition and addressing, uncheck "Compose
  messages in HTML format".
...
- You need to get Thunderbird into preformat mode:
. If you compose HTML messages by default, it's not too hard.
"

The conflicting suggestions make sense if you know it's describing
three different alternatives, but that's not immediately obvious.  So
it's was easier for me to explain the specific method I use.

Alan
