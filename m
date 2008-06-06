Return-Path: <linux-kernel-owner+w=401wt.eu-S932150AbYFFThk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbYFFThk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 15:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbYFFTha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 15:37:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:11252 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbYFFTh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 15:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=organization:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id:from;
        b=nslbNaOBA6jRe/rhvH69WGv837XrpiFeBMn/bBzHFWHkFAxXkTb/kzlgFlTfkrwWd2
         MLLMAVNZQt4zihkHW8Gv3gRY9t5dS0l4vURIPbdLlynW6yJ3bkmvBROWZbmP/DO+JuWJ
         9M5RO7eGrBRGyy6/83YhX8flK3m/LtsL4B7iQ=
Organization: M1K0
To: Andrew Morton <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Date: Fri, 6 Jun 2008 21:37:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <200806060039.48488.m1k0@wp.pl> <20080606034738.9835782d.akpm@linux-foundation.org>
In-Reply-To: <20080606034738.9835782d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806062137.22994.Michal.Kudla@gmail.com>
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W liście datowanym na piątek, 6 czerwca 2008, Andrew Morton pisze:
>AM > [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
>AM
>AM Thanks.  Do you know if it worked in 2.6.24 or 2.6.25?

I checked:
- vanilla-sources-2.6.24.7 (works),
- gentoo-sources-2.6.25-r4 (don't work)

I uploaded files:
.config-2.6.23
.config.2.6.24.7
.config.2.6.25-gentoo-r4
.config-2.6.26
dmesg-2.6.23
dmesg-2.6.24.txt
dmesg-2.6.25.txt
dmesg-2.6.26
http://michal.kudla.googlepages.com/iwlwifi-problem-2.bz2

more infos about 2.6.25 anf iwlwifi:
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1657 
http://bugs.gentoo.org/show_bug.cgi?format=multiple&id=218565 
