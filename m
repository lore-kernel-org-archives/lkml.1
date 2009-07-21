Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZGUO2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZGUO2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 10:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbZGUO2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 10:28:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:58173 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZGUO2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 10:28:36 -0400
Date: Tue, 21 Jul 2009 17:28:33 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Artem Bityutskiy <dedekind1@gmail.com>
Cc: Felipe Balbi <me@felipebalbi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/4] staging: cpc-usb: convert comment style in cpc.h
Message-ID: <20090721142833.GA20401@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1248180746-18140-1-git-send-email-me@felipebalbi.com>
 <1248180746-18140-2-git-send-email-me@felipebalbi.com>
 <4A65CF81.9070008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A65CF81.9070008@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Jul 2009 14:28:15.0114 (UTC) FILETIME=[7BCA8EA0:01CA0A0F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 21, 2009 at 04:24:01PM +0200, ext Artem Bityutskiy wrote:
> If you decided to clean this up, then how about using better
> commenting style documented in Documentation/CodingStyle?
> 
> Namely, Use
> /*
>   * blah
>   */
> 
> style.
> 
> Also, how about making sentences start from a capital letter,
> and re-format the whole comment better?

the patch is only about converting comment style and that's all. Any
other changes I left for other cleanup patches which are being cooked.

-- 
balbi
