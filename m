Return-Path: <linux-kernel-owner+w=401wt.eu-S1761816AbXFDTZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761816AbXFDTZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759837AbXFDTZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:25:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39329 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829AbXFDTZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:25:00 -0400
Date: Mon, 4 Jun 2007 21:24:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately? II
Message-ID: <20070604192459.GB14844@one.firstfloor.org>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011407.51779.jbarnes@virtuousgeek.org> <20070601211943.GO7217@one.firstfloor.org> <200706011441.57149.jbarnes@virtuousgeek.org> <m1r6orwptz.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0706041420100.25811@p34.internal.lan> <20070604192323.GA14844@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604192323.GA14844@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> because the desktop ICH can only access 35bits (8GB) in hardware.
Should be 33bits of course.

-Andi
