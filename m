Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZFDSzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZFDSzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZFDSy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:54:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091AbZFDSy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:54:56 -0400
Date: Thu, 4 Jun 2009 11:53:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard =?ISO-8859-1?Q?R=9A=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Added timbgpio
Message-Id: <20090604115343.b5b4dbb7.akpm@linux-foundation.org>
In-Reply-To: <4A27C3B0.5000605@mocean-labs.com>
References: <4A262F54.3090106@mocean-labs.com>
	<20090604005119.6b4f80e0.akpm@linux-foundation.org>
	<4A27C3B0.5000605@mocean-labs.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Jun 2009 14:53:04 +0200 Richard R____jfors <richard.rojfors.ext@mocean-labs.com> wrote:

> Timberdale is the MFD driver for the FPGA which among other expose this GPIO device.
> This patch set will depend on patches in i2c-ocores and xilinx_spi which I have posted
> earlier on the corresponding mailinglists.
> Shall I repost those driver changes within this patch set, or can I leave them out?

Resend everything in a single sequence-numbered patchset, Ccing every
relevant person (including myself) and mailing list on everything. 
That should cover it ;)

Please also identify any merging-order interdependencies between the
individual patches.

If it all looks OK then the chances are that I'll merge it all into my
tree and than shall take care of maintainer-bugging for you.

