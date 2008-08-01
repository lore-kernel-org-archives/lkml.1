Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbYHAI6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbYHAI6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 04:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYHAI6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 04:58:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50980 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYHAI6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 04:58:04 -0400
Date: Fri, 01 Aug 2008 17:56:55 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Halesh S" <halesh.s@india.com>
Subject: Re: mlock() return value issue in kernel 2.6.23.17
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, madhvesh.s@ap.sony.com,
       halesh.sadashiv@ap.sony.com
In-Reply-To: <20080801083046.15330CB59C@ws5-11.us4.outblaze.com>
References: <20080801083046.15330CB59C@ws5-11.us4.outblaze.com>
Message-Id: <20080801173122.FEC6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Thanks everyone.
> I confirm that the patch fixes the issue with Rlimit and invalid address.
> 
> Signed-off-by: halesh.sadashiv@ap.sony.com

No.
your test program need run as root.
then, it doesn't test rlimit.




