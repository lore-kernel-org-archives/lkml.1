Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbYFXPqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbYFXPqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYFXPqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:46:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50698 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYFXPqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:46:46 -0400
Message-ID: <4861169A.8060309@zytor.com>
Date: Tue, 24 Jun 2008 08:45:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, yhlu.kernel@gmail.com,
       steiner@sgi.com, travis@sgi.com, linux-kernel@vger.kernel.org,
       ying.huang@intel.com, andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/5 v2] x86 boot: various E820 & EFI related fixes - what
 changed in v2
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>	<20080624111903.GD8695@elte.hu> <20080624063049.428ad287.pj@sgi.com>
In-Reply-To: <20080624063049.428ad287.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> 
> Agreed.  I like Huang's follow up suggestion to that as well:
>> I think it is better to add a command-line flag "auxmem"
> 
> It seems to have better backward compatibility, as Huang states.
> 

I would very much agree with that.  Cool!

	-hpa

