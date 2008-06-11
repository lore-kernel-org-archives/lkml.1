Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYFKJvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYFKJvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 05:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYFKJvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 05:51:24 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:29733 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752330AbYFKJvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 05:51:23 -0400
Message-ID: <484F9FEA.7000407@panasas.com>
Date: Wed, 11 Jun 2008 12:50:34 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Benny Halevy <bhalevy@panasas.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] linux-staging tree created
References: <20080610190540.GA25066@kroah.com> <484F9A7B.4080004@panasas.com>
In-Reply-To: <484F9A7B.4080004@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2008 09:50:38.0219 (UTC) FILETIME=[9A3555B0:01C8CBA8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Halevy wrote:
> Greg,
> 
> The OSD initiator (see
> http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=summary)
> looks in principle like a great fit for linux-staging.
> 

The patches are not yet there, Benny. They are currently 
out-of-tree here:
http://git.open-osd.org/gitweb.cgi?p=osd-lib.git;a=summary

It will take me until end of next week to separate them into
a consumable patchset. Which will also move them in-tree.
 
> What would be the mechanics of including it?
> 

I want to send them to linux-scsi-ml and also To: Greg KH
Requesting to be included in "linux-staging tree". Is that
sufficient?

> Benny
> 

Boaz

> On Jun. 10, 2008, 22:05 +0300, Greg KH <greg@kroah.com> wrote:
>> Oh great, not yet-another-kernel-tree, just what the world needs...
>>
>> Yes, this is an announcement of a new kernel tree, linux-staging.  It is
>> a quilt series of patches that can be found at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
>>
>>
<snip>

