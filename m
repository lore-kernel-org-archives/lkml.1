Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbYIYAiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbYIYAiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 20:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYIYAiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 20:38:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33896 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbYIYAiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 20:38:12 -0400
Message-ID: <48DADD5D.9010703@zytor.com>
Date: Wed, 24 Sep 2008 17:37:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yan Li <elliot.li.tech@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware guest detection for x86 and x86-64
References: <48D12490.5010003@zytor.com> <48da36b9.160d6e0a.22a5.ffffec9d@mx.google.com> <48DA6887.1060709@zytor.com> <20080925003220.GE21049@yantp.cn.ibm.com>
In-Reply-To: <20080925003220.GE21049@yantp.cn.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yan Li wrote:
> 
> If you can tell me what manufacture vendor string is in Virtual PC I
> can make another similar patch using dmi_name_in_vendors().
> 

Supposedly "Microsoft Corporation", "Virtual Machine".  No idea what 
pre-MS versions of VPC return.

	-hpa
