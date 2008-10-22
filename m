Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbYJVRwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbYJVRwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760511AbYJVRt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:49:58 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:56314 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760501AbYJVRt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:49:56 -0400
Message-ID: <48FF6797.2030909@nortel.com>
Date: Wed, 22 Oct 2008 11:49:11 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linuxppc-dev@ozlabs.org,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: build failure on powerpc with current -git
References: <48F8E86B.702@nortel.com> <18685.27030.529655.761257@cargo.ozlabs.ibm.com> <20081021191324.d4810d40.sfr@canb.auug.org.au> <18686.42209.47915.184451@cargo.ozlabs.ibm.com>
In-Reply-To: <18686.42209.47915.184451@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2008 17:49:13.0293 (UTC) FILETIME=[7EAAA7D0:01C9346E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:

> Chris, could you try just the following change (my previous patch
> without the arch/powerpc/boot/wrapper change) and let me know if it
> fixes things with the ld you use?

The build completes with no errors.  Haven't actually booted it though.

Gets my vote...

Chris
