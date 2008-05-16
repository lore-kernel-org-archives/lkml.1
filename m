Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbYEPR2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbYEPR2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYEPR2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:28:15 -0400
Received: from outbound-mail-02.bluehost.com ([69.89.21.12]:38927 "HELO
	outbound-mail-02.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752249AbYEPR2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:28:14 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Miklos Vajna <vmiklos@frugalware.org>
Subject: Re: [PATCH] x86: janitor work in irq.c
Date: Fri, 16 May 2008 10:28:06 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <1210696736-31805-1-git-send-email-vmiklos@frugalware.org>
In-Reply-To: <1210696736-31805-1-git-send-email-vmiklos@frugalware.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805161028.06197.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 13, 2008 9:38 am Miklos Vajna wrote:
> Wrapped long lines, removed trailing whitespaces, fixed case indentation
> inside switch and so.
>
> Signed-off-by: Miklos Vajna <vmiklos@frugalware.org>

Applied, thanks (though I had to fix up a couple of trailing whitespaces in 
comments. :).

Jesse
