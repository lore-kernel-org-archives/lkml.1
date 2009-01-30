Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZA3R51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZA3R51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 12:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZA3R5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 12:57:18 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:59447 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbZA3R5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 12:57:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RgBTqyhFSqbSnofrzvfjG0/PT/Msrh4BLC2jnOywV6oT3X+v4BMWA8MbNZIlF2Nriy
         K03u6unEBzWsafqMKgXfO4KkSSPzOrlM7kMu9augQg9RT20xi17SWIbXN2CruK9fGC+W
         i7IAzmoehI4cgXWchTUzBj1szrtZIn2tSTL0c=
MIME-Version: 1.0
In-Reply-To: <497E595F.2010708@gmail.com>
References: <200901231759.n0NHxKA3009104@eng-pool-55.spikesource.com>
	 <200901262004.16364.arnd@arndb.de> <497E595F.2010708@gmail.com>
Date: Fri, 30 Jan 2009 23:27:14 +0530
Message-ID: <85e5430e0901300957x64951d6at2a79c5cb1ee88e97@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: syscalls: sys_setrlimit64/sys_getrlimit64 calls 
	to provide FSIZE limits > 2^32-1
From: Narendra Prasad Madanapalli <narendramind@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       torvalds@osdl.org, linux-api@vger.kernel.org,
       mtk.manpages@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Can you provide me more information on how to port these system calls
to 32-on-64 kernel.

Thanks,
Narendra.
