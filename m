Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbZLJVgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbZLJVgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbZLJVgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:36:53 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12519 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbZLJVgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:36:52 -0500
Message-ID: <4B2169A8.5080503@caviumnetworks.com>
Date: Thu, 10 Dec 2009 13:35:36 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [Uclinux-dist-devel] [PATCH 5/5] blackfin: Convert BUG() to use
 	unreachable()
References: <4B212EEC.3060808@caviumnetworks.com> <1260466101-17545-5-git-send-email-ddaney@caviumnetworks.com> <8bd0f97a0912101333x2ba210d8ib1936bffa0ef2d7b@mail.gmail.com>
In-Reply-To: <8bd0f97a0912101333x2ba210d8ib1936bffa0ef2d7b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2009 21:35:36.0562 (UTC) FILETIME=[B5F18520:01CA79E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Thu, Dec 10, 2009 at 12:28, David Daney wrote:
>> Use the new unreachable() macro instead of for(;;);
> 
> sorry, i guess i missed this back in Sept.  change looks fine to me
> (i'll test it later when finishing putting together other patches).
> you want me to push though my queue ?  doesnt matter to me.

Yes, if you test it and are happy with it.  I have no queue and plan no 
further action.

David Daney
