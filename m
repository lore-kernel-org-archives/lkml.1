Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbYGELOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbYGELOJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYGELN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:13:56 -0400
Received: from il.qumranet.com ([212.179.150.194]:50995 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbYGELN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:13:56 -0400
Message-ID: <486F5771.4020209@qumranet.com>
Date: Sat, 05 Jul 2008 14:13:53 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make kvm_smp_prepare_boot_cpu() static
References: <20080630221918.GI1536@cs181140183.pp.htv.fi>
In-Reply-To: <20080630221918.GI1536@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the needlessly global kvm_smp_prepare_boot_cpu() static.
>
>   

Applied, thanks.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

