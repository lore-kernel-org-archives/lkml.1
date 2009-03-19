Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbZCSN5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbZCSN5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbZCSN5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:57:10 -0400
Received: from smtp.nokia.com ([192.100.122.230]:43543 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbZCSN5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:57:08 -0400
Date: Thu, 19 Mar 2009 15:39:54 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Peta Blaha <blahapeta@gmail.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] input/joystick: add driver fortius 1942
Message-ID: <20090319133953.GB18295@scadufax.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <739e73230903190651w4fff7aaen818a42540ffbdc8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <739e73230903190651w4fff7aaen818a42540ffbdc8d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 19 Mar 2009 13:56:51.0859 (UTC) FILETIME=[8E0FA630:01C9A89A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 02:51:07PM +0100, ext Peta Blaha wrote:
> Driver for Fortius 1942 device.
> 
> Signed-off-by: Petr Blaha <blahapeta@gmail.com>

It's not that long. you can send it to the list.

It also makes our life easier when trying to comment on the patch. Just
run scripts/checkpatch.pl --strict on your patch file before sending it
and solve any issues reported by that tool.

Also, that Signed-off-by line is not needed in the driver itself.

-- 
balbi
