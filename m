Return-Path: <linux-kernel-owner+w=401wt.eu-S1751240AbZCIMfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbZCIMfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 08:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbZCIMfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 08:35:46 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:16797 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZCIMfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 08:35:45 -0400
Message-ID: <49B50D1B.5050807@turknet.net.tr>
Date: Mon, 09 Mar 2009 14:35:39 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b4pre) Gecko/20090308 Lightning/1.0pre Shredder/3.0b3pre
MIME-Version: 1.0
To: david@lang.hm
CC: David Newall <davidn@davidnewall.com>, linux-kernel@vger.kernel.org
Subject: Re: Failover Kernel
References: <49A659D0.2040903@turknet.net.tr>  <200902261802.56612.diegocg@gmail.com>  <49A80796.2070208@turknet.net.tr> <1235749850.4718.1.camel@localhost.localdomain> <49AC0799.5060306@turknet.net.tr> <49ACA433.5050400@davidnewall.com> <49AE3BF6.2010600@turknet.net.tr> <alpine.DEB.1.10.0903051707211.30837@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0903051707211.30837@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2009 12:35:40.0583 (UTC) FILETIME=[8E6C6B70:01C9A0B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2009 03:10 AM, david@lang.hm wrote:
> wrong, kernel structures can change in any patch. they can even change 
> with different configuration options.
>
> but even if they are the same version and configuration options, that 
> doesn't address the fact that you can't trust the in-kernel structures 
> because they may have been damaged by whatever caused the crash.
>
> David Lang

Sorry for late reply. I was away for a while. Hmmm... I understood. It 
seems, it's not so possible. Thanks for who replied to this thread.
