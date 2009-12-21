Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbZLUVpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbZLUVpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 16:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbZLUVpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 16:45:05 -0500
Received: from smtp.nokia.com ([192.100.105.134]:60524 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbZLUVpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 16:45:04 -0500
Date: Mon, 21 Dec 2009 23:42:36 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: Alex Deucher <alexdeucher@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>
Subject: Re: [Oops:] radeon KMS in 2.6.33-rc1-00154-gf7b84a6
Message-ID: <20091221214235.GA11558@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <200912212238.54069.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <200912212238.54069.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Dec 2009 21:43:35.0916 (UTC) FILETIME=[A63462C0:01CA8286]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 21, 2009 at 10:38:53PM +0100, ext Johannes Hirte wrote:
>When loading the radeon module with modeset=1, the kernel oopses:

[snip]

>Dec 21 21:58:14 datengrab firmware.sh[2542]: Cannot find  firmware file
>'radeon/R600_rlc.bin'

does it have something to do with the missing firmware file ??

-- 
balbi
