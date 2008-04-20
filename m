Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbYDTPvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbYDTPvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 11:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYDTPvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 11:51:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:19017 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYDTPvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 11:51:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZBVk0Lxe6mF+JBJc8s6Fy182tdEnS55ca+Q64CAzqb44y6s3dqg3XX2i8D2QfaFHTMOqenL/Gd5Gq8cMQ3hZbicy3KtvJ7sRem5/63EfkarcoU28f06Do2yq3Xi9T/joy4s+P90uo2lsUe7Pe1Kj3jqbftFfKVLqZHitqs+cHTo=
Message-ID: <480B6676.3030908@gmail.com>
Date: Sun, 20 Apr 2008 17:51:18 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26
References: <20080420072053.6bcb7884.akpm@linux-foundation.org>
In-Reply-To: <20080420072053.6bcb7884.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2008 04:20 PM, Andrew Morton wrote:
> These can be found at
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1

>  #
>  # Misc
>  #
[...]
>  misc-phantom-add-compat-ioctl.patch
>  misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
>  misc-phantom-fix-poll.patch
>  misc-phantom-consistent-whitespace.patch

OK to be merged, I suppose.

> Mostly-merge, subject to re-review.

