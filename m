Return-Path: <linux-kernel-owner+w=401wt.eu-S1758407AbZDCAh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407AbZDCAh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZDCAhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:37:14 -0400
Received: from sous-sol.org ([216.99.217.87]:47117 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754021AbZDCAhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:37:13 -0400
Date: Thu, 2 Apr 2009 17:35:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Message-ID: <20090403003523.GK18394@sequoia.sous-sol.org>
References: <200904011155.20751.a.miskiewicz@gmail.com> <20090402210451.GA4076@elte.hu> <200904022328.02088.rjw@sisk.pl> <200904030222.57469.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904030222.57469.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> What about 9ea09af3bd3090e8349ca2899ca2011bd94cda85 ?
> 
> stop_machine: introduce stop_machine_create/destroy.

That is later fixed in a0e280e0f33f6c859a235fb69a875ed8f3420388.

Can you please verify if 2.6.29 works for you?  Your bisects are all
going way back to 2.6.29-rc1.

thanks,
-chris
