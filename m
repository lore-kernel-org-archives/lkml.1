Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0B1Nyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 08:54:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:36008 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab0B1Ny3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 08:54:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Uljoxx6g1OWF+j2r0w78cc2R3OfUfsFVq5FY3x9dMMuNdTvWpK6qfeg442U0/adov4
         sKcoBrs9yOqKWBNU4hDzkqTl2v0zebyxTgm5zmkN77a5pNT+P0AvDnk87u2ch8ESo4o9
         HQjxJvGFNxlYPakRa45mPCtluiNiSMGKvCkR0=
MIME-Version: 1.0
In-Reply-To: <7d01f9f01002271418j185821a3h447c89a43406254d@mail.gmail.com>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
	 <1267289508-31031-33-git-send-email-andrea.gelmini@gelma.net>
	 <7d01f9f01002271418j185821a3h447c89a43406254d@mail.gmail.com>
Date: Sun, 28 Feb 2010 14:54:26 +0100
X-Google-Sender-Auth: 902715f160ef8a19
Message-ID: <9cdbb57f1002280554u2f06ce7g86cfef6eeb3abc0d@mail.gmail.com>
Subject: Re: [PATCH 32/66] arch/parisc/include/asm/parport.h: Checkpatch 
	cleanup
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: Thibaut VARENE <T-Bone@parisc-linux.org>
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/27 Thibaut VARENE <T-Bone@parisc-linux.org>:

Hi Thubaut,
   thanks a lot for you answer.

> This looks very much in contradiction with CodingStyle, since
> parport_pc_find_nonpci_ports() is a function, and it's not a fix for
> the quoted "WARNING". I'm guessing this wasn't intended the way it is.

My fault. I'll look at checkpatch.pl regexp to resolve false positive
(I've found a few other regressions).

Thanks again,
Andrea
