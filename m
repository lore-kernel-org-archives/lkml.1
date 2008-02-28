Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbYB1KRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbYB1KRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYB1KR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:17:26 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:55213
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbYB1KRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:17:25 -0500
Message-ID: <47C68A31.6040608@qumranet.com>
Date: Thu, 28 Feb 2008 12:17:21 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: KVM and mce64 suspend trace
References: <c4e36d110802280211w79b88622qc8e5a3770277fdbd@mail.gmail.com>
In-Reply-To: <c4e36d110802280211w79b88622qc8e5a3770277fdbd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zdenek Kabelac wrote:
> Hi
>
> While doing suspend/resume with running qemu I've got this trace log -
> unsure whether this is a problem or not - using git tree 64bit
> 2.6.25-rc3, CPU C2D
>   

It's not a problem in practice but I do plan to rework the locking to 
avoid that message.


-- 
error compiling committee.c: too many arguments to function

