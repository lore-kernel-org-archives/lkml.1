Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab0CINz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 08:55:26 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:9362 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751306Ab0CINzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 08:55:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAIvhlUtLd/sX/2dsb2JhbAAHgwTDKZBigTKCXWoEgxc
X-IronPort-AV: E=Sophos;i="4.49,608,1262581200"; 
   d="scan'208";a="57791364"
Message-ID: <4B965348.3050201@teksavvy.com>
Date: Tue, 09 Mar 2010 08:55:20 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       tytso@mit.edu, "H. Peter Anvin" <hpa@zytor.com>,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org>
In-Reply-To: <4B947393.2050002@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/10 22:48, Tejun Heo wrote:
..
> Please note that hdparm is misreporting the alignment offset.  It
> should be reporting 512 instead of 256 for offset-by-one drives.
..

That issue was fixed quite a while ago.
Upgrade your elderly copy of hdparm.

:)
