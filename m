Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0CBQFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 11:05:33 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:54208 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab0CBQFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 11:05:32 -0500
X-SpamScore: -29
X-BigFish: VPS-29(zz1432R98dN936eM9371Pzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B8D370A.4030609@am.sony.com>
Date: Tue, 2 Mar 2010 08:04:26 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCHv2] drivers: net: optimize hex2bin()
References: <4B8C485A.8000409@am.sony.com> <1267516766-25977-1-git-send-email-andy.shevchenko@gmail.com>
In-Reply-To: <1267516766-25977-1-git-send-email-andy.shevchenko@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Mar 2010 16:04:26.0719 (UTC) FILETIME=[087796F0:01CABA22]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 11:59 PM, Andy Shevchenko wrote:
> Optimize hex2bin() function used in ps3_gelic_wireless.c. It requires to have
> hex_to_bin() implementation introduced by starter patch [1] in series.
> 
> [1] http://patchwork.kernel.org/patch/81224/
> 
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> Cc: Geoff Levand <geoffrey.levand@am.sony.com>
> ---
>  drivers/net/ps3_gelic_wireless.c |   13 +++++--------
>  1 files changed, 5 insertions(+), 8 deletions(-)

Looks good, thanks.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

