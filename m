Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYHUXdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYHUXdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbYHUXdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:33:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63487 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366AbYHUXdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:33:20 -0400
X-Greylist: delayed 9436 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2008 19:33:20 EDT
Date: Thu, 21 Aug 2008 13:33:17 -1000
From: Joshua Hoblitt <josh@hoblitt.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080821233317.GE23377@hoblitt.com>
References: <bug-11388-27@http.bugzilla.kernel.org/> <20080820180405.7f164450.akpm@linux-foundation.org> <86802c440808201820w6c684a10y2f1d0f70a344a14a@mail.gmail.com> <86802c440808201849k6665c395x5a5b871eca55addd@mail.gmail.com> <20080821205558.GC23377@hoblitt.com> <86802c440808211451u4483f88ft845cd20c3f23c53a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808211451u4483f88ft845cd20c3f23c53a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 02:51:43PM -0700, Yinghai Lu wrote:
> can you check that with tip/master?
> 
> http://people.redhat.com/mingo/tip.git/readme.txt

I'm doing that now.  Note that I was pulling from netdev-2.6 before.

-J

--
