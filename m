Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab0BRQjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:39:43 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:30704 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325Ab0BRQjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:39:41 -0500
Message-ID: <4B7D6D08.9080600@oracle.com>
Date: Thu, 18 Feb 2010 08:38:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org, Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for February 18 (staging)
References: <20100218204937.54a613d2.sfr@canb.auug.org.au>
In-Reply-To: <20100218204937.54a613d2.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B7D6D35.001D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/10 01:49, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20100217:


duplicated function name:

drivers/staging/built-in.o: In function `format_by_fourcc':
(.text+0x5667): multiple definition of `format_by_fourcc'
drivers/media/built-in.o:(.text+0x2d241): first defined here


in drivers/staging/cx25821/ and drivers/media/common/saa7146_video.c

-- 
~Randy
