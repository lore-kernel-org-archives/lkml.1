Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbYDJNL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbYDJNL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 09:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbYDJNLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 09:11:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38257 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198AbYDJNLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 09:11:18 -0400
Date: Thu, 10 Apr 2008 14:10:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080410131058.GH26575@flint.arm.linux.org.uk>
References: <20080207133805.13f092ff@dilbert.local> <20080207130222.GA8587@flint.arm.linux.org.uk> <20080207141236.00940d09@dilbert.local> <20080211092547.09bca061@dilbert.local> <20080410122127.GA8096@digi.com> <20080410122706.GG26575@flint.arm.linux.org.uk> <20080410125709.GA11038@digi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080410125709.GA11038@digi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 02:57:09PM +0200, Uwe Kleine-König wrote:
> After Hans-Jürgen addressed your concerns about the order in
> arch/arm/Kconfig compared to drivers/Kconfig there was no addional
> feedback (apart from the discussion about including drivers/Kconfig in
> arch/arm/Kconfig).

Ah, that issue (a brief synopsis helps!)

> and the following post includes the last version of the patch:
> 
> 	http://lists.arm.linux.org.uk/lurker/message/20080207.131236.8c4f4569.en.html

That looks fine.
