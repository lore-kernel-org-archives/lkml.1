Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbYBETSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbYBETSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbYBETSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:18:43 -0500
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:58380 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbYBETSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:18:42 -0500
Date: Tue, 5 Feb 2008 11:18:06 -0800
From: Robin Lee Powell <rlpowell@digitalkingdom.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Monthly md check == hung machine; how do I debug?
Message-ID: <20080205191806.GC9284@digitalkingdom.org>
References: <20080203212155.GF12173@digitalkingdom.org> <200802042140.55521.nickpiggin@yahoo.com.au> <20080205171005.GA9284@digitalkingdom.org> <20080205185517.GE26259@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205185517.GE26259@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 01:55:17PM -0500, Lennart Sorensen wrote:
> I tend to adjust the max disk speed raid is allowed to use, since
> the default of 200MB/s makes the system close to unusable while it
> is taking place.  Could having slow disk access be causing things
> to lock up?

I don't know if it could or not, but I have no performance problems
at all when the sync is running, as long as it doesn't lock up, so
it seems unlikely to me.

(Shout out to a fellow CSC sysadmin, btw.)

-Robin

-- 
Lojban Reason #17: http://en.wikipedia.org/wiki/Buffalo_buffalo
Proud Supporter of the Singularity Institute - http://singinst.org/
http://www.digitalkingdom.org/~rlpowell/ *** http://www.lojban.org/
