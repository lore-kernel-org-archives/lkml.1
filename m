Return-Path: <linux-kernel-owner+w=401wt.eu-S1161189AbXBAFjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161189AbXBAFjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 00:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161191AbXBAFjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 00:39:46 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:40937 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161189AbXBAFjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 00:39:46 -0500
Subject: Re: 2.6.19.2 oops after resume from ram (corruption?)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1170307834.7087.16.camel@Homer.simpson.net>
References: <1170241008.6512.10.camel@Homer.simpson.net>
	 <1170279722.5389.19.camel@nigel.suspend2.net>
	 <1170307834.7087.16.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 16:39:41 +1100
Message-Id: <1170308381.32500.29.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2007-02-01 at 06:30 +0100, Mike Galbraith wrote:
> Rebuilding this particular kernel with slab debugging would probably be
> a waste of time since stable kernels get very little runtime here, but
> I'll re-add it to my config for test kernels just in case a survivable
> event should happen.

Thanks, Mike.

Regards,

Nigel

