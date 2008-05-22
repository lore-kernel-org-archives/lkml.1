Return-Path: <linux-kernel-owner+w=401wt.eu-S1760911AbYEVXPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbYEVXPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbYEVXPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:15:41 -0400
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:34792 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759972AbYEVXP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:15:26 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: write_pci_config_byte fix offset
Date: Thu, 22 May 2008 16:14:58 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805210012.35939.yhlu.kernel@gmail.com> <200805221435.21969.yhlu.kernel@gmail.com>
In-Reply-To: <200805221435.21969.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221614.58362.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 22, 2008 2:35 pm Yinghai Lu wrote:
> also add write_pci_config_16
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Applied to linux-next, thanks Yinghai.

Jesse
