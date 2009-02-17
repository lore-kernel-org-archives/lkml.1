Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZBQXWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZBQXWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZBQXVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:21:55 -0500
Received: from mail.lang.hm ([64.81.33.126]:44544 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbZBQXVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:21:54 -0500
Date: Tue, 17 Feb 2009 15:21:52 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Wilcox <matthew@wil.cx>
cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com
Subject: Re: mpt fusion broken sometime since 2.6.24
In-Reply-To: <20090217231101.GH16841@parisc-linux.org>
Message-ID: <alpine.DEB.1.10.0902171521330.26625@asgard.lang.hm>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <alpine.DEB.1.10.0902171343280.26625@asgard.lang.hm> <20090217230050.GG16841@parisc-linux.org> <alpine.DEB.1.10.0902171506500.26625@asgard.lang.hm> <20090217231101.GH16841@parisc-linux.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Matthew Wilcox wrote:

> Date: Tue, 17 Feb 2009 16:11:01 -0700
> From: Matthew Wilcox <matthew@wil.cx>
> To: david@lang.hm
> Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
>     DL-MPTFusionLinux@lsi.com
> Subject: Re: mpt fusion broken sometime since 2.6.24
> 
> On Tue, Feb 17, 2009 at 03:07:26PM -0800, david@lang.hm wrote:
>>> mptbase.mpt_msi_enable_sas=0
>>
>> is that disabling SAS for this system? if so, that's the wrong thing to do
>> (the drives are SAS)
>
> no, it's disabling msi for sas controllers.
>
> nb, I said this patch (e382968ba618e016ff7922dff9a6140c2f9108c8) was
> the wrong way to go about getting MSI working.

same boot messages, I'll get the lspci in a few min

David Lang
