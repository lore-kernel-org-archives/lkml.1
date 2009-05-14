Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbZENOKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbZENOKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 10:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbZENOKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 10:10:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55670 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbZENOKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 10:10:04 -0400
Message-ID: <4A0C251B.9030101@zytor.com>
Date: Thu, 14 May 2009 07:05:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       "Xin, Xiaohui" <xiaohui.xin@intel.com>, "Li, Xin" <xin.li@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       rostedt <rostedt@rostedt.homelinux.com>
Subject: Re: Performance overhead of paravirt_ops on native identified
References: <4A0B62F7.5030802@goop.org>  <4A0B6F9C.4060405@zytor.com> <1242289506.6642.901.camel@laptop>
In-Reply-To: <1242289506.6642.901.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> 
> This sounds remarkably like what the dynamic function call tracer does.
> 

I'm sure this has been invented before... probably more than once.  Far
too many things we invent don't get generalized.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

