Return-Path: <linux-kernel-owner+w=401wt.eu-S1767439AbXECWOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767439AbXECWOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 18:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767444AbXECWOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 18:14:48 -0400
Received: from outmail1.freedom2surf.net ([194.106.33.237]:59041 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767439AbXECWOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 18:14:47 -0400
Subject: Re: [Kernel-discuss] [PATCH 3/8] Universal power supply class
	(was: battery class)
From: ian <spyro@f2s.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Greg KH <gregkh@suse.de>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
In-Reply-To: <20070503213139.GC20067@zarina>
References: <20070503213139.GC20067@zarina>
Content-Type: text/plain
Date: Thu, 03 May 2007 23:14:26 +0100
Message-Id: <1178230466.20102.27.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 01:31 +0400, Anton Vorontsov wrote:
>     # cat /sys/class/power\ supply/ac/type
>         AC
> 
>         # cat /sys/class/power\ supply/usb/type
>         USB 

isnt that a bit redundant?

I'd have thought sys/class/power\ supply/supplyX/type would be better?

