Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbXLGV2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbXLGV2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 16:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXLGV1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 16:27:53 -0500
Received: from hpsmtp-eml12.KPNXCHANGE.COM ([213.75.38.112]:20011 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754508AbXLGV1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 16:27:52 -0500
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patches] libata fixes
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-To: <20071207203401.GA29005@havoc.gtf.org>
References: <20071207203401.GA29005@havoc.gtf.org>
Message-Id: <E1J0kjd-0006zE-SG@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Fri, 07 Dec 2007 22:27:49 +0100
X-OriginalArrivalTime: 07 Dec 2007 21:27:50.0012 (UTC) FILETIME=[04A723C0:01C83918]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> libata disabling command queueing (aka NCQ) based on some hueristics for
> detection device brokenness.... that ultimately turned out to be broken.
> 
> Remove the broken hueristic and turn NCQ back on for all the wrongfully
> maligned hard drives.

Yay!
