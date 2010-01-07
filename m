Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869Ab0AGTgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0AGTgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386Ab0AGTgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:36:11 -0500
Received: from er-systems.de ([85.25.136.202]:54118 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab0AGTgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:36:10 -0500
Date: Thu, 7 Jan 2010 20:36:07 +0100 (CET)
From: Thomas Voegtle <tv@lio96.de>
To: Greg KH <gregkh@suse.de>
cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, dmonakhov@openvz.org
Subject: Re: Linux 2.6.31.10
In-Reply-To: <20100107180449.GA17495@suse.de>
Message-ID: <alpine.LNX.2.00.1001072033301.26784@er-systems.de>
References: <20100106234533.GC1960@kroah.com> <alpine.LNX.2.00.1001071522480.5426@er-systems.de> <20100107180449.GA17495@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.95.3/10267/Thu Jan  7 03:04:56 2010 signatures .
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, Greg KH wrote:

> On Thu, Jan 07, 2010 at 03:27:21PM +0100, Thomas Voegtle wrote:
>> Hi,
>>
>> On Wed, 6 Jan 2010, Greg KH wrote:
>>> I'm announcing the release of the 2.6.31.10 kernel.  All users of the
>>> 2.6.31 kernel series are very strongly encouraged to upgrade.
>>
>>
>> Something broken here, during using a suse 11.2 installation with quota
>> switched on (this is reproducible )
>
> Jan, this looks like something in the quota patches you sent.  Any
> ideas?
>
> Thomas, is this on an ext3 or ext4 partition, or something else?


The one with quota enabled was an ext3 partition, mounted on /


thanks,
  Thomas

