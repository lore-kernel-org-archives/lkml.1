Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYBLWWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYBLWWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYBLWV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:21:56 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:34587 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbYBLWVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:21:55 -0500
Message-ID: <47B21C01.9070608@ct.jp.nec.com>
Date: Tue, 12 Feb 2008 14:21:53 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] RTTIME watchdog timer proc interface
References: <47B0C1D4.5080808@ct.jp.nec.com> <1202766767.6247.16.camel@lappy>
In-Reply-To: <1202766767.6247.16.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-02-11 at 13:44 -0800, Hiroshi Shimamoto wrote:
>> Hi Ingo,
>>
>> I think an interface to access RLIMIT_RTTIME from outside is useful.
>> It makes administrator able to set RLIMIT_RTTIME watchdog to existing
>> real-time applications without impact.
>>
>> I implemented that interface with /proc filesystem.
> 
> /proc/<pid>/tasks/<tid>/rttime might also make sense.
> 
thanks, I'll add.

