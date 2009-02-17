Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbZBQVpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbZBQVpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZBQVpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:45:07 -0500
Received: from mail.lang.hm ([64.81.33.126]:59782 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZBQVpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:45:04 -0500
Date: Tue, 17 Feb 2009 13:44:55 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel <linux-kernel@vger.kernel.org>
cc: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com
Subject: Re: mpt fusion broken sometime since 2.6.24
In-Reply-To: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
Message-ID: <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a picture of the failed boot at 
http://linux.lang.hm/linux/IMG00052.jpg

David Lang

On Tue, 17 Feb 2009, david@lang.hm wrote:

> Date: Tue, 17 Feb 2009 14:24:27 -0800 (PST)
> From: david@lang.hm
> To: linux-kernel <linux-kernel@vger.kernel.org>
> Cc: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com
> Subject: mpt fusion broken sometime since 2.6.24
> 
> I have some systems with the MPT fusion raid cards in them and SAS drives, 
> they work find on the 2.6.24 'etch and a half' debian kernel, but when I try 
> and install a 2.6.28 kernel there are numerous timeouts during boot and the 
> raid array is not recognised.
>
> I tried a 2.6.27 kernel I have laying around and got the same results with 
> it.
>
> is this a known problem with a work-around? or am I just lucky enough to be 
> the only one hitting this?
>
> David Lang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
