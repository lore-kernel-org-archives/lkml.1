Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbYIGEfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbYIGEfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 00:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYIGEfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 00:35:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:24905 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbYIGEfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 00:35:11 -0400
Message-ID: <1a6b76aa0809062135n4d0710c7sf7332d6b4e63cdad@mail.gmail.com>
Date: Sat, 6 Sep 2008 21:35:07 -0700
From: "Steven Noonan" <steven.noonan@uplinklabs.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
Cc: "Alain Knaff" <alain@knaff.lu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48C34803.60006@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>
	 <48C34803.60006@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2008 at 8:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Alain Knaff wrote:
>>
>> This version applies to kernel 2.6.26.3
>>
>
> Could you produce a version against the -tip tree, either the master branch
> or the x86/setup branch?

I second this.

I tested the existing patch, and it works great when applied to
2.6.26. It'd be great to see a version of this either go into -mm or
mainline sometime soon.

- Steven
