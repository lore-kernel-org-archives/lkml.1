Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbYIXQVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbYIXQVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYIXQVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:21:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44277 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYIXQVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:21:45 -0400
Message-ID: <48DA68FF.3030202@zytor.com>
Date: Wed, 24 Sep 2008 09:21:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alok kataria <alokkataria1@gmail.com>
CC: Yan Li <elliot.li.tech@gmail.com>,
       Cristi Magherusan <cristi.magherusan@net.utcluj.ro>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com,
       akataria@vmware.com, Zachary Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
References: <48D12490.5010003@zytor.com>	 <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com>	 <1222265424.5708.5.camel@localhost>	 <20080924142322.GA21049@yantp.cn.ibm.com> <35f686220809240919x631d8f98m5f1d20c2c8e98690@mail.gmail.com>
In-Reply-To: <35f686220809240919x631d8f98m5f1d20c2c8e98690@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok kataria wrote:
> 
> Btw, are you pushing these patches for the 2.6.27 release ? If this is
> for the x86 tree(2.6.28) i think we should hold on, until i post the
> proposal for the cpuid patches, so that we can unify this and have a
> generic way to detect on which hypervisor are we running .
> 

I don't think there is any way in hell this is going into 2.6.27.

For it to make 2.6.28 it will have to be ready very soon.

	-hpa
