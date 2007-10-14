Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbXJNR1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbXJNR1Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753681AbXJNR1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:27:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41099 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbXJNR1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:27:17 -0400
Date: Sun, 14 Oct 2007 10:26:57 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "werner" <werner@monkey.is-a-geek.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: problems kernel 2.6.23-git4
Message-ID: <20071014102657.33cf9c2d@laptopd505.fenrus.org>
In-Reply-To: <1192380846.30891@monkey.is-a-geek.net>
References: <1192380846.30891@monkey.is-a-geek.net>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Oct 2007 13:54:07 -0300 (GFT)
"werner" <werner@monkey.is-a-geek.net> wrote:

> Since kernel 2.6.23-rc9 and also with 2.6.23 -git4 crashs X often :
> I changed nothing; only the kernel.  Today I reinstalled xorg; kde
> completely - problem continues.  Proble, not using old kernel. Im
> using now ext3  rather than ext4; no filesistem problems:  thus i
> believe its a kernel problem.  dmesg  and X crash protocoll annexed:
> the crash protocol is always similar

if you have a X log of X that doesn't crash.. it's interesting to look
at the diff between the two logs to see if there are any hints in
that...
