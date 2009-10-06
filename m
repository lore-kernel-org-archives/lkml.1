Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZJFBpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZJFBpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 21:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbZJFBpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 21:45:22 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:55761 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbZJFBpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 21:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QFvmXx7Z9IXRGOmz5wHKR91E6knJN7UtoMVCpP8Y4q+Qpb70ZHW6WKE7H6nmBp9OSI
         JuFjkMt0sxayOFteln6yL/1zzrDBWCHr4ybPVoByllNJpX8EXXkwDDeuNvbW98+D0qxu
         lVcQ8QIp5Ue/7NN8Le0T0raH2NdmtVqXv+WMU=
MIME-Version: 1.0
In-Reply-To: <4ACA2C5C.6000402@mandriva.org>
References: <51f3faa70909290740l4f4df186w114bf48e1db3a948@mail.gmail.com>
	 <20091001085002.1dbc7eee@hyperion.delvare>
	 <51f3faa70910010740s2a412d07qf29f56ad8a3c59eb@mail.gmail.com>
	 <20091001144914.GA18675@nb-core2.darkstar.lan>
	 <4AC4D6F5.6080005@mandriva.org>
	 <68676e00910011205t506604e5y5a0a04fec0821dc0@mail.gmail.com>
	 <20091002122636.GA25505@nb-core2.darkstar.lan>
	 <4AC665E4.8060200@mandriva.org>
	 <20091005152751.GA10011@nb-core2.darkstar.lan>
	 <4ACA2C5C.6000402@mandriva.org>
Date: Mon, 5 Oct 2009 19:44:43 -0600
Message-ID: <51f3faa70910051844u5a09887cm778bfa1b44bfa23d@mail.gmail.com>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
From: Robert Hancock <hancockrwd@gmail.com>
To: Thomas Backlund <tmb@mandriva.org>
Cc: Luca Tettamanti <kronos.it@gmail.com>, Jean Delvare <khali@linux-fr.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "astarikovskiy@suse.de" <astarikovskiy@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 5, 2009 at 11:26 AM, Thomas Backlund <tmb@mandriva.org> wrote:
>>>>> I see. GITM probably expects the same buffer structure as SITM, though
>>>>> in older models the upper bits were never used (hence I never noticed
>>>>> the problem). Working on a patch.
>>>>
>>>> Ok, here it is:
>>>
>>> no go...
>>
>> Ok, I should have fixed the OOPS.
>>
>
> Yep.
> This one works so...
>
> Tested-by: Thomas Backlund <tmb@mandriva.org>

Works for me as well.

Tested-by: Robert Hancock <hancockrwd@gmail.com>
