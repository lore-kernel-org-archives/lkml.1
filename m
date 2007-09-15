Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbXIOSeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbXIOSeV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXIOSeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:34:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35524 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbXIOSeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:34:13 -0400
Date: Sat, 15 Sep 2007 20:34:12 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: crashme fault
Message-ID: <20070915183412.GA14501@one.firstfloor.org>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com> <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Andi, anything comes to mind?

No, unfortunately not. There weren't any changes to entry.S recently
that could corrupt the error code as far as I remember. Also cannot think of 
something else.

A version where it started happening would be useful.

-Andi
