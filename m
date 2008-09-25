Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbYIYA12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbYIYA12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 20:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYIYA1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 20:27:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34069 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbYIYA1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 20:27:18 -0400
Message-ID: <48DADAC6.2080500@zytor.com>
Date: Wed, 24 Sep 2008 17:26:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yan Li <elliot.li.tech@gmail.com>
CC: Alok kataria <alokkataria1@gmail.com>,
       Cristi Magherusan <cristi.magherusan@net.utcluj.ro>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com,
       akataria@vmware.com, Zachary Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <1222265424.5708.5.camel@localhost> <20080924142322.GA21049@yantp.cn.ibm.com> <35f686220809240919x631d8f98m5f1d20c2c8e98690@mail.gmail.com> <20080925001521.GB21049@yantp.cn.ibm.com>
In-Reply-To: <20080925001521.GB21049@yantp.cn.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yan Li wrote:
> 
> My motivation behind this patch is to serve the MTRR codes to fix a
> false warning,

It's not a false warning.  It's a true warning.

	-hpa
