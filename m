Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0CIOcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 09:32:09 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:21952 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752423Ab0CIOcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 09:32:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAO/qlUtLd/sX/2dsb2JhbAAHgwTDfZBkgTKCXWoEgxc
X-IronPort-AV: E=Sophos;i="4.49,608,1262581200"; 
   d="scan'208";a="57794466"
Message-ID: <4B965BE5.6060700@teksavvy.com>
Date: Tue, 09 Mar 2010 09:32:05 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       tytso@mit.edu, "H. Peter Anvin" <hpa@zytor.com>,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Karel Zak <kzak@redhat.com>,
       Jim Meyering <jim@meyering.net>
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net>	<4B95B623.9040705@kernel.org> <yq1bpey89o9.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1bpey89o9.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/10 22:18, Martin K. Petersen wrote:
>>>>>> "Tejun" == Tejun Heo<tj@kernel.org>  writes:
>
> Tejun>  Yeah, I know Mark fixed it but couldn't find where the tree was.
> Tejun>  SF only had old releases, so...
>
> Tejun>  (other stuff replied further down the thread)
>
> Looks like Mark hasn't made an hdparm release since I posted the patch.
..

Holy crap.  I thought I'd put that out months ago!

Anyway, it's there now:  https://sourceforge.net/projects/hdparm/

Thanks!
