Return-Path: <linux-kernel-owner+w=401wt.eu-S1761707AbYEVXQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761707AbYEVXQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbYEVXQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:16:06 -0400
Received: from outbound-mail-124.bluehost.com ([67.222.38.24]:42067 "HELO
	outbound-mail-124.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755911AbYEVXQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:16:05 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: early dump pci conf space v2
Date: Thu, 22 May 2008 16:15:20 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805210012.35939.yhlu.kernel@gmail.com> <200805221435.11734.yhlu.kernel@gmail.com>
In-Reply-To: <200805221435.11734.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221615.21134.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 22, 2008 2:35 pm Yinghai Lu wrote:
> so we can printout pci config before kernel touch it
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Also applied to linux-next, this is a nice debugging feature.

Thanks,
Jesse
