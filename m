Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbZD0StU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbZD0StU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757804AbZD0StH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:49:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41567 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbZD0StG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:49:06 -0400
Date: Mon, 27 Apr 2009 20:53:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Styner, Douglas W" <douglas.w.styner@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
       "Ma, Chinang" <chinang.ma@intel.com>, Andi Kleen <andi@firstfloor.org>,
       "willy@linux.intel.com" <willy@linux.intel.com>
Subject: Re: Discrepancies between Oprofile and vmstat II
Message-ID: <20090427185305.GG27382@one.firstfloor.org>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com> <87ljpmk29b.fsf@basil.nowhere.org> <D7C42C27E6CB1E4D8CBDF2F81EA92A26034598724F@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D7C42C27E6CB1E4D8CBDF2F81EA92A26034598724F@azsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> opcontrol -e=CPU_CLK_UNHALTED:80000 -e=LLC_MISSES:6000
> 
> Using another profiling tool to confirm, we see 74.784% user, 25.174% kernel.

Just verifying -- you also see it when you use a shorter period than 80000 right?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
