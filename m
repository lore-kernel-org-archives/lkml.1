Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbZFYQXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbZFYQXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 12:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZFYQXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 12:23:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZFYQXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 12:23:45 -0400
Message-ID: <4A43A3E4.9040701@zytor.com>
Date: Thu, 25 Jun 2009 09:20:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend
 to 	disk, mce related?
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>	 <4A3E7F38.7030300@linux.intel.com>	 <8db1092f0906211313x73ac9340n9af5775b56cfd189@mail.gmail.com>	 <4A3EE668.5090400@jp.fujitsu.com> <4A417176.40008@jp.fujitsu.com>	 <4A41C4E2.5080206@linux.intel.com> <8db1092f0906250853g7aa1af09w678b700780eabcd3@mail.gmail.com>
In-Reply-To: <8db1092f0906250853g7aa1af09w678b700780eabcd3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> 
> Are this patches was added to -rc1?
> 

No, but they're in our push queue.  Since they're bug fixes they will be
pushed after we have run tests on them.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

