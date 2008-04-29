Return-Path: <linux-kernel-owner+w=401wt.eu-S932578AbYD2QOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbYD2QOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbYD2QO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:14:29 -0400
Received: from outbound-mail-151.bluehost.com ([67.222.39.31]:40828 "HELO
	outbound-mail-151.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751946AbYD2QO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:14:29 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: yhlu.kernel@gmail.com
Subject: Re: [PATCH] x86/pci: remove flag in pci_cfg_space_size_ext
Date: Tue, 29 Apr 2008 09:14:16 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080426185516.GA32364@elte.hu> <200804281334.16713.jbarnes@virtuousgeek.org> <200804281627.23566.yhlu.kernel@gmail.com>
In-Reply-To: <200804281627.23566.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804290914.16742.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 28, 2008 4:27 pm Yinghai Lu wrote:
> so let pci_cfg_space_size call it directly without flag.
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Thanks Yinghai.

Ingo, I assume you'll roll this in?

Jesse
