Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbYIVHBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbYIVHBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 03:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYIVHBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 03:01:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51430
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbYIVHBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 03:01:35 -0400
Date: Mon, 22 Sep 2008 00:01:23 -0700 (PDT)
Message-Id: <20080922.000123.172220747.davem@davemloft.net>
To: airlied@gmail.com
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, david.vrabel@csr.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
From: David Miller <davem@davemloft.net>
In-Reply-To: <21d7e9970809212359y6876c405ub57dca3e9ee737e4@mail.gmail.com>
References: <7lIhZC4hCxE.A.yj.E2q1IB@albercik>
	<20080921.165159.67476441.davem@davemloft.net>
	<21d7e9970809212359y6876c405ub57dca3e9ee737e4@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Airlie" <airlied@gmail.com>
Date: Mon, 22 Sep 2008 16:59:51 +1000

> I've reconstructed my boot timeline from message logs
> 
> Sep 3rd, I booted rawhide kernel 2.6.27-0.290.rc5.fc10.i686

What upstream SHA1 is this based upon?

> I suspended/resume a few times in between with no issues.
> 
> Sep 8th I booted my own 2.6.27-rc5 kernel based from
> ec0c15afb41fd9ad45b53468b60db50170e22346
> 
> This got a corrupted e1000e checksum and every kernel since has.

Ok.
