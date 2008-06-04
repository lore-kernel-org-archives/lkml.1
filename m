Return-Path: <linux-kernel-owner+w=401wt.eu-S1759189AbYFDKo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189AbYFDKo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYFDKoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:44:16 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:36343
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbYFDKoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:44:15 -0400
Message-ID: <4846716E.5000506@qumranet.com>
Date: Wed, 04 Jun 2008 13:41:50 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>, avi@qumranet.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kvm: unable to handle kernel NULL pointer dereference
References: <20080601084802.GA3146@yamamaya.is-a-geek.org>
In-Reply-To: <20080601084802.GA3146@yamamaya.is-a-geek.org>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Hi,
>
> I get the following Oops when trying to start qemu-kvm
> (Debian/unstable kvm package version 60+dfsg-1) on my system:
>
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> IP: [<ffffffff8021d44f>] svm_vcpu_run+0x34/0x351
>   


kvm-60 is quite old. Can you try kvm-69?


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

