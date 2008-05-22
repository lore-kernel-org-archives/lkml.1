Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYEVSm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYEVSm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYEVSmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:42:49 -0400
Received: from outbound-mail-132.bluehost.com ([67.222.39.22]:51201 "HELO
	outbound-mail-132.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754645AbYEVSms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:42:48 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: early dump pci conf space
Date: Thu, 22 May 2008 11:42:28 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805210012.35939.yhlu.kernel@gmail.com>
In-Reply-To: <200805210012.35939.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221142.28511.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 21, 2008 12:12 am Yinghai Lu wrote:
> so we can printout pci config before kernel touch it
>
> also fix write_pci_config_byte with offset
> and add write_pci_config_16

I like the idea.  Can you submit the write config byte fix separately?  I'll 
queue it up for 2.6.27 unless there are other comments.

Thanks,
Jesse
