Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbXCZUpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbXCZUpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbXCZUpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:45:34 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:36697 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbXCZUpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:45:33 -0400
Date: Mon, 26 Mar 2007 16:45:08 -0400
From: Kyle McMartin <kyle@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kyle@canonical.com
Subject: Re: HPA patches
Message-ID: <20070326204508.GC21164@athena.road.mcmartin.ca>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 07:13:21PM +0000, Alan Cox wrote:
> For reference this is what I am currently using with 2.6.21-rc4-mm1 and
> it is working for all my test cases so far: Its basically Kyle's patch
> with a libata switch to turn it on/off and some minor fixups from
> the original patch as posted
> 

This looks good to me. Thanks for picking this up!

Acked-By: Kyle McMartin <kyle@canonical.com>

Cheers,
	Kyle M.
