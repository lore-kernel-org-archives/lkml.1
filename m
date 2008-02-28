Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbYB1OmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbYB1OmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 09:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYB1OmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 09:42:00 -0500
Received: from hpsmtp-eml18.KPNXCHANGE.COM ([213.75.38.118]:46480 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbYB1Ol7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 09:41:59 -0500
To: zkopex mtrof <zkopex@yahoo.com>
Subject: Re: [Regression in 2.6.25-rcX] CD/DVD writer no longer works
Cc: efault@gmx.de, linux-kernel@vger.kernel.org
In-reply-To: <916729.18642.qm@web45209.mail.sp1.yahoo.com>
References: <1203910587.12670.9.camel@homer.simson.net> <916729.18642.qm@web45209.mail.sp1.yahoo.com>
Message-Id: <E1JUjxL-0001wm-Cg@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Thu, 28 Feb 2008 15:41:55 +0100
X-OriginalArrivalTime: 28 Feb 2008 14:41:57.0300 (UTC) FILETIME=[11976F40:01C87A18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zkopex mtrof wrote:
> Thank you very much! The patch you supplied fixes the regression!
> 
> What do we need to do in order to get this patch applied in
> mainline so that the regression gets fixed?
> 
> To be honest, I was expecting a few replies from the appropriate
> kernel developers. It looks like I have missed something in
> my regression report.

This did happen in a different thread. Looks like a final patch has now been
found which can be expected in mainline soon. See:
http://lkml.org/lkml/2008/2/28/76

Cheers,
FJP
