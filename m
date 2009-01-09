Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbZAIX0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbZAIX0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760695AbZAIX0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:26:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52040 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760690AbZAIX0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:26:14 -0500
Message-ID: <4967DD26.1040101@zytor.com>
Date: Fri, 09 Jan 2009 15:26:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tvignaud@mandriva.com" <tvignaud@mandriva.com>
Subject: Re: [patch] x86, pat: fix reserve_memtype() for legacy 1MB range
References: <20090109223520.GC6472@linux-os.sc.intel.com> <4967D223.1090703@zytor.com> <20090109224804.GD6472@linux-os.sc.intel.com> <4967D5FB.5020302@zytor.com> <20090109231316.GE6472@linux-os.sc.intel.com>
In-Reply-To: <20090109231316.GE6472@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
>> Permission to map and memory type should not be connected.  Just to 
>> clarify, when mapped, was it still WB?
> 
> yes it is. It's just treated and tracked differently.

OK, cool.  Just wanted to check.

	-hpa
