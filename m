Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbZCKREy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbZCKREy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZCKREo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:04:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56412 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZCKREn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:04:43 -0400
Message-ID: <49B7EEEA.3080203@zytor.com>
Date: Wed, 11 Mar 2009 10:03:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Woody Suwalski <woodys@xandros.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: x86: removing zImage support?
References: <49B703D4.1000008@zytor.com> <49B7C729.5080301@xandros.com>
In-Reply-To: <49B7C729.5080301@xandros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Woody Suwalski wrote:
>>   
> If x86-only - OK.
> 
> However zImage is the format used on ARM quite often... So any "kernel
> complexity removal" need to happen only on x86 side.
> 

I have no idea about ARM zImage... the whole zImage vs bzImage is pretty
x86-specific in the first place, so yes, I was referring to x86
specifically.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

