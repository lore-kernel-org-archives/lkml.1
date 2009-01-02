Return-Path: <linux-kernel-owner+w=401wt.eu-S932335AbZABVaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbZABVaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 16:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758374AbZABV3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 16:29:54 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:5732 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758272AbZABV3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 16:29:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cSGxAIqbjxOwWZdxQ6tJpnP3wUigjU/gi3HQPwCXHeFt6v6KwjUR5GDddAiJSE22NO
         yugHPxfhCKUcwZ/mGVMNS2LrgXfQkis+o/Aw600bGsd+tgNKnpvvVlqyFbZ/SeD+dd9B
         6wTBY+mEOgfceOsXgisWAnCoXQgHQz3KCWMuY=
Message-ID: <8752a8760901021329s1c96b753q26fd4b7a5041aa09@mail.gmail.com>
Date: Fri, 2 Jan 2009 21:29:51 +0000
From: "Ben Goodger" <goodgerster@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
In-Reply-To: <8752a8760901021328t545a0327v58faebe1e921680a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <8752a8760901021328t545a0327v58faebe1e921680a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/2 Ben Goodger <goodgerster@gmail.com>
>
> 2009/1/2 Linas Vepstas <linasvepstas@gmail.com>
>>
>> Slashdot reported a story of Linux machines crashing on New years eve.
>>
>> So far, 31 users reported 53 hard crashes at/near midnight, new years.
>
> Further details about my crash (Goodgerster):
> -- system works normally after reboot;
> -- no messages were written to /var/log/kernel;
> -- affected machine was running 2.6.26-1-amd64 from Debian testing;
> -- the other machine on the network was unaffected (to the extent that it continues normal operation as an NFS server) and is running 2.6.18 from Debian Etch;
> -- the affected machine was using NTP (not sure about the server machine.)
>
> I was unable to find any logs on the Etch machine that would tell us whether the affected machine continued writing to its NFS share after the crash. File corruption is evident, but this would have been caused by the hard reset or the crash in equal measure. Unfortunately, I was careless enough to just hit the reset button after hitting ctrl-alt-backspace a couple of times, but I know that either the X window system or the kernel hung entirely (I do not know whether the NumLock key was inoperable, but the cursor/system monitor/clock stopped moving. The clock displayed 23:59:59 when I returned to it at around 00:15. I am in the UTC+0 timezone; the system clock was therefore in UTC, but I had set it to "windows compatibility" mode (i.e. local timezone).
>
> Hope this helps (?)...
>
> --
> Benjamin Goodger
>
> -----BEGIN GEEK CODE BLOCK-----
> Version: 3.1
> GCS/S/M/B d- s++:-- a18 c++$ UL>+++ P--- L++>+++ E- W+++$ N--- K? w--- O? M- V? PS+(++) PE-() Y+ PGP+ t 5? X-- R- !tv() b+++>++++ DI+++ D+ G e>++++ h! !r*(-) y
> ------END GEEK CODE BLOCK------



--
Benjamin Goodger

-----BEGIN GEEK CODE BLOCK-----
Version: 3.1
GCS/S/M/B d- s++:-- a18 c++$ UL>+++ P--- L++>+++ E- W+++$ N--- K? w---
O? M- V? PS+(++) PE-() Y+ PGP+ t 5? X-- R- !tv() b+++>++++ DI+++ D+ G
e>++++ h! !r*(-) y
------END GEEK CODE BLOCK------
