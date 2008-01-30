Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbYA3Rgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbYA3Rgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbYA3Rgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:36:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53157 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbYA3Rgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:36:39 -0500
Message-ID: <47A0B57C.8010101@zytor.com>
Date: Wed, 30 Jan 2008 09:35:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: yi.y.yang@intel.com
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC PATCH 2.6.24] x86: add sysfs interface for cpuid module,
 try 2
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>	 <1201562058.12722.9.camel@yangyi-dev.bj.intel.com> <1201650080.3875.1.camel@yangyi-dev.bj.intel.com>
In-Reply-To: <1201650080.3875.1.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yi Yang wrote:
> This patch is try 2, it should cover VIA/Cyrix and Transmeta Crusoe, please
> help to test it if anybody has VIA/Cyrix and Transmeta Crusoe. This patch just
> makes users get cpuid raw data more conveniently by
> /sys/devices/syste/cpu/cpu*/cpuid/* without using any userspace application.

Still completely useless garbage.

	-hpa
