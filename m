Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbZJFLCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbZJFLCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 07:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932124AbZJFLCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 07:02:17 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:60651 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756942AbZJFLCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 07:02:16 -0400
From: Frans Pop <elendil@planet.nl>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
Date: Tue, 6 Oct 2009 13:01:35 +0200
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, jeff.chua.linux@gmail.com,
       Valdis.Kletnieks@vt.edu, mangoo@wpkg.org, daniel.blueman@gmail.com,
       bstanoszek@comtime.com, dave@linux.vnet.ibm.com,
       hugh.dickins@tiscali.co.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hugh@veritas.com
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com> <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com> <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain> <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain> <200910061106.33718.tvrtko.ursulin@sophos.com>
In-reply-To: <200910061106.33718.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910061301.39221.elendil@planet.nl>
X-OriginalArrivalTime: 06 Oct 2009 11:01:39.0932 (UTC) FILETIME=[617EA1C0:01CA4674]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko Ursulin wrote:
>> In fact, I wish more people did that, just so that we'd get better
>> coverage of the 32-bit compat code. We occasionally find issues there,
>> although I think it's getting rarer.
> 
> Maybe convince some distro to offer this setup as an option at least? I
> always wondered why no one has, or maybe I missed it.

Debian has a 64-bit kernel for its 32-bit "i386" architecture (and also for 
its 64-bit "amd64" architecture obviously):
- for stable: http://packages.debian.org/lenny/linux-image-2.6.26-2-amd64
- for unstable: http://packages.debian.org/sid/linux-image-2.6.30-2-amd64

Cheers,
FJP
