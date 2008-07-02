Return-Path: <linux-kernel-owner+w=401wt.eu-S1763927AbYGBLtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763927AbYGBLtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759066AbYGBLse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:48:34 -0400
Received: from il.qumranet.com ([212.179.150.194]:56648 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758342AbYGBLse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:48:34 -0400
Message-ID: <486B6B0E.7090503@qumranet.com>
Date: Wed, 02 Jul 2008 14:48:30 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [-mmotm] some different buliding failures
References: <486B1EE0.9060303@cn.fujitsu.com> <20080702040127.779a25c5.akpm@linux-foundation.org>
In-Reply-To: <20080702040127.779a25c5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> OK, I uploaded another mmotm (http://userweb.kernel.org/~akpm/mmotm/). 
> It passes i386 allnoconfig and allmodconfig.  Heaven knows what it does
> at runtime.  We'll take a look at that tomorrow.
>
> People have been madly adding new warnings.  I don't know how this
> happens.
>
> kvm is particularly noisy.
>   

I'm sure you have before, but can you remind me how to figure out what 
commit to apply mmotm onto?  I looked in series and origin.patch, but no 
luck.  Applying on top of the last (first) commit in origin.patch's head 
did not work.

Also, can I suggest including series in b-o.tar.gz?  Nice to have 
everything in one tarball.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

