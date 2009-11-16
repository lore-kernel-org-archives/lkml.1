Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbZKPE6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbZKPE6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZKPE6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:58:31 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:11689 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZKPE6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:58:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Mzme0N/RBYvfWUROalupx5uhlCdHSfp3z3laCTsYnGX5aiCwJkW0fvyA58OQdzqf8U
         tDfCBnmcA+N4OIxdV11vwxhynZsToHF4nfCnsBlb8MwcjeBFuW/UtiwKdhe81d6BUBxd
         FzGjn1avSlmYkLpgVDOiC+/c9S0UWwwRkwbfo=
MIME-Version: 1.0
In-Reply-To: <72981EBCFD196144B7C6999B9FC34A9A494C18F160@SHEXMB-01.global.atheros.com>
References: <a44ae5cd0911111141i56c067f2we01cfef857133081@mail.gmail.com>
	 <a44ae5cd0911111158w4985a6a0n2b30da3421a1b46b@mail.gmail.com>
	 <72981EBCFD196144B7C6999B9FC34A9A494C18F02B@SHEXMB-01.global.atheros.com>
	 <a44ae5cd0911152018qf913307n5506fc2772fc5e60@mail.gmail.com>
	 <72981EBCFD196144B7C6999B9FC34A9A494C18F160@SHEXMB-01.global.atheros.com>
Date: Sun, 15 Nov 2009 23:58:36 -0500
Message-ID: <a44ae5cd0911152058t1f3dc625y7be54fc38c79652a@mail.gmail.com>
Subject: Re: 2.6.32-rc6-git4 -- NetworkManager: page allocation failure. 
	order:8, mode:0x8020
From: Miles Lane <miles.lane@gmail.com>
To: Jie Yang <Jie.Yang@atheros.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jay Cliburn <jcliburn@gmail.com>,
       Chris Snook <chris.snook@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 15, 2009 at 11:27 PM, Jie Yang <Jie.Yang@atheros.com> wrote:
> On  Sent: Monday, November 16, 2009 12:18 PM
> Miles Lane <miles.lane@gmail.com> wrote:
>
>> Cc: LKML; Jay Cliburn; Chris Snook
>> Subject: Re: 2.6.32-rc6-git4 -- NetworkManager: page
>> allocation failure. order:8, mode:0x8020
>>
>> I download the latest linux tarball in bz2 format from
>> ftp.kernel.org and then apply the patches there.  For example:
>>
>>     tar xvfj linux-2.6.31.tar.bz2
>>     cd linux
>>     bzcat ../patch-2.4.32-rc6.bz2 | patch -p1
>>     bzcat ../patch-2.4.32-rc6-git4.bz2 | patch -p1
>
> just confused, why use the 2.4.X patch??

Whoops.  That was a typo on my part.
