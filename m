Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbYHFWQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbYHFWQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYHFWQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:16:26 -0400
Received: from waste.org ([66.93.16.53]:37731 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbYHFWQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:16:21 -0400
Subject: Re: [PATCH] bootup: Add built-in kernel command line for x86
From: Matt Mackall <mpm@selenic.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <489A1844.3090502@am.sony.com>
References: <489A1844.3090502@am.sony.com>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 17:14:33 -0500
Message-Id: <1218060873.7576.2.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-08-06 at 14:31 -0700, Tim Bird wrote:
> The default behavior is to append the boot loader string
> to this one.  However, there is a mechanism (leading '!')
> to force the built-in string to override the boot loader
> string.

Nice solution.

Where is this relative to early boot option checking?

-- 
Mathematics is the supreme nostalgia of our time.

