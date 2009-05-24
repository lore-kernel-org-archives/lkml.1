Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZEXIwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZEXIwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 04:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZEXIw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 04:52:27 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:47688 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZEXIw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 04:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HsTJVdOj2YcHEehBnFw4G+nBixEGMSkloZwR9epzX7T0Zi1s1u4/najjnIXY2CWlqX
         MBW4CKlhaXafV2plCoENLlCVwpUeQGPGpdPoAEmjKTzymfhWw7Kh+2O3eCizme62uoSa
         P6lTKgYV1gyo3J6x9vR79yNQdFeaazgnR6ywA=
MIME-Version: 1.0
In-Reply-To: <1243154319.16741.38.camel@odie.local>
References: <75608D7C7FD141D1B20D3AC37A6C77A3@tdsdev>
	 <1243154319.16741.38.camel@odie.local>
Date: Sun, 24 May 2009 11:52:26 +0300
X-Google-Sender-Auth: a6a76a77dd2f1abb
Message-ID: <84144f020905240152t9dbf69bjcfe635749f4a5828@mail.gmail.com>
Subject: Re: a couple quick kernel questions
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: =?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?= <odie@cs.aau.dk>
Cc: Tyler Littlefield <tyler@tysdomain.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/24 Simon Holm Thøgersen <odie@cs.aau.dk>:
> lør, 23 05 2009 kl. 17:14 -0600, skrev Tyler Littlefield:
>> Hello all,
>> My name is tyler; I'm new to the list, and new to kernel development.
>> I'd like to find a way I can help out, though I don't have huge servers or a
>> bunch of hardware to build and test drivers on.
>> Is there a position somewhere where I can learn, and contribute something?
>>
>> Also, my kernel modules is about 75 mb. I'm trying to figure out if there's
>> a place that describes all the config options so I can easily go through and
>> choose what I want. 75 mb isn't bad, but I'd rather not be using the extra
>> overhead, especially if I don't need it.
>
> Use make menuconfig or make config and read the help text for the
> various options.

You might want to speed up the process with this script:

http://rostedt.homelinux.com/code/streamline_config.pl
