Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbYA1Nne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbYA1Nne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 08:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbYA1NnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 08:43:11 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47427 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759904AbYA1NnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:43:09 -0500
Date: Mon, 28 Jan 2008 08:43:08 -0500
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>
Subject: Re: LinuxPPS patch
Message-ID: <20080128134308.GC16173@csclub.uwaterloo.ca>
References: <20080127173923.GT11364@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127173923.GT11364@enneenne.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 06:39:23PM +0100, Rodolfo Giometti wrote:
> here my patch for PPS support against kernel 2.6.24:
> 
>    http://ftp.enneenne.com/pub/misc/linuxpps/patches/ntp-pps-2.6.24.diff
> 
> The code has been tested by some guys intered in PPS stuff and it
> seems ok. :)
> 
> Please report your suggestions in order to get kernel inclusion.

I would test it except I am still on 2.6.18 and probably will be for
quite a while.  I am still using an older patch of yours which works
great for now, although I know the interface has a changed a bit since.

--
Len Sorensen
