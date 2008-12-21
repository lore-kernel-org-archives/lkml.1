Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYLUJII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYLUJII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 04:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYLUJHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 04:07:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:10077 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYLUJHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 04:07:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=g0HESJmz8BmQhPIP9WMs7Ut+SyrmeU6wbokJgpII/+Q3LpmUWMNJq2nG8YggF8hAn6
         Sf60gx9gYebYWsUSBE7oJPjooaGyOBZ12hmDiBe5gFlesu8Engpj8WhdfH94NH//vTn4
         mLEdZ1G5pkB5djYDyaQlhlKPy7H+b6IfzgAwo=
Message-ID: <84144f020812210107k4be14431s4fb61f2d31da8621@mail.gmail.com>
Date: Sun, 21 Dec 2008 11:07:48 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.28-rc9-git1: Reported regressions from 2.6.27
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera>
X-Google-Sender-Auth: 47e998479f217018
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 11:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12156
> Subject         : v2.6.28-rc2: x86_32 relocation regression?
> Submitter       : Vegard Nossum <vegard.nossum@gmail.com>
> Date            : 2008-11-24 21:19 (27 days old)
> References      : http://marc.info/?l=linux-kernel&m=122756158220966&w=4

I think this one has a fix in x86.git:

http://lkml.org/lkml/2008/12/18/224
