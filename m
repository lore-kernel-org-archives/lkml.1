Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbYHTXG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbYHTXG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 19:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYHTXGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 19:06:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59671 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbYHTXGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 19:06:46 -0400
Message-ID: <48ACA35C.7060907@zytor.com>
Date: Wed, 20 Aug 2008 16:06:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [OT] 'git pull' from Linus' tree doesn't work for me any more
References: <200808210045.42693.rjw@sisk.pl> <alpine.LFD.1.10.0808201548300.3487@nehalem.linux-foundation.org> <200808210058.06515.rjw@sisk.pl>
In-Reply-To: <200808210058.06515.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>>
>> It starts working after a few minutes when the rsync has completed.
> 
> Well, it hasn't been working for a couple of hours now ...
> 

My fault; I forgot to kick xinetd after updating the configuration file 
for the git-daemon -> git daemon rename.

	-hpa
