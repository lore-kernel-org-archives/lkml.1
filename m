Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbZFUGP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbZFUGP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 02:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZFUGPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 02:15:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237AbZFUGPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 02:15:18 -0400
Date: Sat, 20 Jun 2009 23:14:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux@arm.linux.org.uk
Subject: Re: [PATCH v6] gpio: driver for PrimeCell PL061 GPIO controller
Message-Id: <20090620231425.3df82bc1.akpm@linux-foundation.org>
In-Reply-To: <20090619134332.GG21428@tarshish>
References: <1245220477-6904-1-git-send-email-baruch@tkos.co.il>
	<20090618151916.32d55e6e.akpm@linux-foundation.org>
	<20090619134332.GG21428@tarshish>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009 16:43:32 +0300 Baruch Siach <baruch@tkos.co.il> wrote:

> Should I post v7 of the entire patch, or just a fix-up for these issues?

The driver is in the mainline kernel now, so patches should be against that.

