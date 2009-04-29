Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbZD2VFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbZD2VFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbZD2VFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:05:39 -0400
Received: from mail.tpi.com ([70.99.223.143]:4374 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbZD2VFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:05:38 -0400
Message-ID: <49F8C120.6080807@tpi.com>
Date: Wed, 29 Apr 2009 15:05:36 -0600
From: Tim Gardner <timg@tpi.com>
Reply-To: timg@tpi.com
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [GIT]: staging - mac80211 - unify config_interface and	bss_info_changed
References: <20090429193821.305DAF88CE@sepang.rtg.net> <20090429201947.GB20814@kroah.com>
In-Reply-To: <20090429201947.GB20814@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Apr 29, 2009 at 01:38:21PM -0600, Tim Gardner wrote:
>> Greg,
>>
>> I did a build test to make sure things at least compile. checkpatch is fine
>> with these patches, but the drivers clearly have other formatting issues.
>>
>> Lemme know if you have any problems.
> 
> Only thing that is a problem is that I can't pull 3 individual patches
> out of one email :)
> 
> Care to use git send-email to send them to me?
> 

Done, though I didn't Cc LKML again. I take it this is your preferred
method for receiving patches? I thought you were a git weenie.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
