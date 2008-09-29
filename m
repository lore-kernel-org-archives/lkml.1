Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbYI2HYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbYI2HYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 03:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYI2HYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 03:24:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:34789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbYI2HYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 03:24:39 -0400
Message-ID: <48E0824B.4010408@kernel.org>
Date: Mon, 29 Sep 2008 16:22:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Robert Krawitz <rlk@alum.mit.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Another one for fixup-storage
References: <4897809E.8070902@alum.mit.edu>
In-Reply-To: <4897809E.8070902@alum.mit.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Sep 2008 07:24:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Krawitz wrote:
> This is for a Dell Inspiron E1705/9400.  I'm using a non-OEM disk (a
> Hitachi 320 GB drive).
> 
> Note that matching on "MP061" doesn't work -- it needs to be "MP061*"
> due to the way dmidecode seems to return the data (with a bunch of
> spaces after the tag).  Hence I've attached the data rather than merely
> 
> I've only had this thing a month or so and already had over 70,000
> unload cycles.  Ick.

Can you please attach the result of "smartctl -a" output?

Thanks.

-- 
tejun
