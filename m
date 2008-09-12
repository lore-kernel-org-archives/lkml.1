Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbYILK6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbYILK6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 06:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYILK6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 06:58:42 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:44979 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbYILK6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 06:58:41 -0400
Date: Fri, 12 Sep 2008 12:58:10 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Liam Girdwood <lrg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] WM8400 support
Message-ID: <20080912105809.GB4999@localdomain>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20080910182825.GB16721@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910182825.GB16721@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Sep 10, 2008 at 07:28:25PM +0100, Mark Brown wrote:
> These patches against the regulator development tree add basic support
> for the WM8400, an audio CODEC and PMU targeted at multimedia systems,
> covering basic PMIC functionality only.  Since the functionality of the
> device covers multiple subsystems with arbitration required a core
> driver is provided in drivers/mfd.
> 
> Samuel, I guess it makes sense to merge this via the regulator tree?
Yes, I'm fine with it. I'll ACK the mfd part once we address/answer the
couple points I'm not completely fine with.

Cheers,
Samuel.
