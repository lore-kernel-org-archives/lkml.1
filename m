Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbYH0Xfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbYH0Xfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbYH0XfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:35:07 -0400
Received: from outbound-mail-155.bluehost.com ([67.222.39.35]:57828 "HELO
	outbound-mail-155.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756980AbYH0XfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:35:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=CwQza+FqoY5t3QUnc0qk2KwQCEGtxb0TnGdrNA7yNWUoI7J9PFUs3TJnHCFmX8CoJ9l0geTbQOV/Bb1NwlzzcgC9Y0f9l+K5RvmJMwQM7HnjfsgHg9klWMFGC6nGAiiF;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
Date: Wed, 27 Aug 2008 16:34:42 -0700
User-Agent: KMail/1.9.9
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
References: <1218854205-2375-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1218854205-2375-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271634.45346.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 15, 2008 7:36 pm Yinghai Lu wrote:
> we are using 28bit pci (bus/dev/fn + 12 bits) as irq number, so the
> cache for irq number should be 32 bit too.
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Applied to linux-next, thanks.

Jesse
