Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZFXVok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZFXVok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZFXVod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:44:33 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:62653 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbZFXVoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:44:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D5w00KdDH//DQkuvL00YahSoXa8PgIC+I+g4ZctHXOXPXkhYLoLvpTzZH2XQgB60ar
         +TYkeKwLxmhimtq/Nh85ifxvJ/WmZVzqBWEHVjTYt3oTet4e6ubPJQWzRJDK4k26fMot
         6rsu4KKic8QDKskp/BgH87Ga4ttr+JO3VJGMk=
MIME-Version: 1.0
In-Reply-To: <4A429DAA.3010303@lwfinger.net>
References: <1245845787.3093.3.camel@localhost.localdomain>
	 <1245861219.3216.15.camel@localhost.localdomain>
	 <20090624094411.08fc66e6@jbarnes-g45>
	 <20090624175513.GE7239@us.ibm.com>
	 <20090624112849.55b38fff@jbarnes-g45>
	 <alpine.LFD.2.00.0906242043230.2767@localhost.localdomain>
	 <20090624194839.GG7239@us.ibm.com> <4A4286F8.9020501@lwfinger.net>
	 <86802c440906241432l6d601f76sf2a413d6e19079e6@mail.gmail.com>
	 <4A429DAA.3010303@lwfinger.net>
Date: Wed, 24 Jun 2009 14:44:35 -0700
Message-ID: <86802c440906241444g1aabcc5rb2d189dca0965e36@mail.gmail.com>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Gary Hade <garyhade@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 2:42 PM, Larry Finger<Larry.Finger@lwfinger.net> wrote:
> Yinghai Lu wrote:
>> please fix the whole boot log with debug.
>>
>> need to make sure how many HT chain in your system.
>
> Do you mean the output of dmesg? I'm not sure what you mean by "debug".
>
put debug in your boot line of grub.conf

YH
