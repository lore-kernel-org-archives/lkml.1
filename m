Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbYIAEKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbYIAEKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 00:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYIAEKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 00:10:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46156
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbYIAEKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 00:10:11 -0400
Date: Sun, 31 Aug 2008 21:10:05 -0700 (PDT)
Message-Id: <20080831.211005.22750451.davem@davemloft.net>
To: Valdis.Kletnieks@vt.edu
Cc: rick.jones2@hp.com, jmalicki@metacarta.com, andi@firstfloor.org,
       johnpol@2ka.mipt.ru, dada1@cosmosbay.com, denys@visp.net.lb,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       juhlenko@akamai.com, sammy@sammy.net
Subject: Re: loaded router, excessive getnstimeofday in oprofile
From: David Miller <davem@davemloft.net>
In-Reply-To: <6720.1220242094@turing-police.cc.vt.edu>
References: <20031.1220236756@turing-police.cc.vt.edu>
	<20080831.205145.225080276.davem@davemloft.net>
	<6720.1220242094@turing-police.cc.vt.edu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valdis.Kletnieks@vt.edu
Date: Mon, 01 Sep 2008 00:08:14 -0400

> Quite frankly, unless somebody *IS* planning to become an expert on how the
> IT stuff for them are designed and run, we *should not* be doing any code
> changes that we don't understand, just because they say so and we should
> trust them...

Exactly!  We should not change where and how packet timestamps are
taken!  Thanks!

It is what I have been advocating this whole thread :-)
