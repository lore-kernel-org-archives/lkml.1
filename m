Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0CEK36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 05:29:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:49020 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab0CEK35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 05:29:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=kaKCRKny29SBgDTFaqLWKMU84cZ+LZx2f5OZv0SYx2cZ5Q/KSEMUK1HPCLj/PQUcqo
         GvyMmuUlzSac+PInjznZJx0J1NjWiBnsv69tn19KsTR7Pwhoq8AKzcC5x6KGnH/kQVMI
         BMLhOl/KS2wcjnU6ArCW1Leb23U/DQ6e8O7S8=
MIME-Version: 1.0
In-Reply-To: <4B868701.3010904@asladvancedsys.in>
References: <4B868701.3010904@asladvancedsys.in>
Date: Fri, 5 Mar 2010 11:29:55 +0100
X-Google-Sender-Auth: 278c455c2b1e9c2d
Message-ID: <3efb10971003050229na0fd4fbl128a890b0cf245c0@mail.gmail.com>
Subject: Re: Info on AT91 patches against mainline kernel
From: Remy Bohmer <linux@bohmer.net>
To: Ravi Kumar Kulkarni <ravikulkarni@asladvancedsys.in>
Cc: linux-kernel@vger.kernel.org, Andrew Victor <linux@maxim.org.za>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/2/25 Ravi Kumar Kulkarni <ravikulkarni@asladvancedsys.in>:
> Hi all,
> I want some info on the status of AT91 Patches against the mailine kernel
> tree.I'm having a AT91 SOC board AT91SAM9261. The Note on their website
> (wwwdotlinux4samdotorg)says to get a kernel up on the board we have to apply
> the AT91 patch set maintained by Andrew Victor which is located at
> (http://maxim.org.za/at91_26.html) . There are only patches upto 2.6.31. so
> does tat mean i cannot compile the latest mainline kernel (2.6.33) for my

You do not necessarily need the at91-patchset from Andrew.
2.6.33 works fine on at91sam9261 without it...

Remy
