Return-Path: <linux-kernel-owner+w=401wt.eu-S1751851AbXAVVpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbXAVVpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXAVVpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:45:45 -0500
Received: from legolas.ittc.ku.edu ([129.237.121.181]:59052 "EHLO
	legolas.ittc.ku.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbXAVVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:45:44 -0500
X-Greylist: delayed 1436 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jan 2007 16:45:44 EST
From: noah <nwatkins@legolas.ittc.ku.edu>
Date: Mon, 22 Jan 2007 15:21:52 -0600
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] whitespace cleanup for 2.6.20-rc5-rt7
Message-ID: <20070122212148.GA26295@legolas>
References: <11693256381932-git-send-email-nwatkins@ittc.ku.edu> <20070122195836.GC21277@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070122195836.GC21277@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No script. Does trailing whitespace and spaces before tab indents seem
to cover all the whitespace problem scenarios?

-noah

On Mon, Jan 22, 2007 at 08:58:36PM +0100, Ingo Molnar wrote:
> 
> * Noah Watkins <nwatkins@ittc.ku.edu> wrote:
> 
> > fixes trailing whitespace and spaces before tab indents in 
> > 2.6.20-rc5-rt7 as reported with: git-apply --whitespace=error-all
> 
> thanks. Did you do the patch manually, or do you have a script for that 
> perhaps?
> 
> 	Ingo
