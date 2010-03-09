Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab0CICzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:55:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:34930 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab0CICzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:55:40 -0500
Message-ID: <4B95B843.6030900@kernel.org>
Date: Tue, 09 Mar 2010 11:53:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Karel Zak <kzak@redhat.com>,
       Jim Meyering <jim@meyering.net>
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com>
In-Reply-To: <170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Mar 2010 02:53:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/09/2010 04:34 AM, Mike Snitzer wrote:
> I've been keeping track of all the pieces in play, have coordinated
> with kzak and jim, and have a summary that offers some amount of macro
> detail (at the end I touch on parted and fdisk):
> 
> http://people.redhat.com/msnitzer/docs/io-limits.txt

Ah... this is great.  I'll link the doc and shamelessly steal parts of
it if that's okay with you.

Thanks.

-- 
tejun
