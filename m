Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbZIODf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbZIODf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 23:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbZIODf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 23:35:26 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:34722 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047AbZIODfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 23:35:25 -0400
Date: Mon, 14 Sep 2009 23:33:34 -0400
From: Jeff Dike <jdike@addtoit.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de, David.Woodhouse@intel.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
	'make oldconfig'
Message-ID: <20090915033334.GA16531@c2.user-mode-linux.org>
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org> <20090904144857.GA12872@elte.hu> <alpine.LFD.2.00.0909041631210.14872@twosheds.infradead.org> <4AA13FE6.20807@zytor.com> <20090904183103.GA1873@elte.hu> <4AA16336.3050606@zytor.com> <20090911211654.GA11399@c2.user-mode-linux.org> <4AAED1E2.7060906@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAED1E2.7060906@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 04:29:38PM -0700, H. Peter Anvin wrote:
> Jeff, could you re-send this as a proper patch with an SOB line?

I could - I wanted to get it out for comment first in case anyone had
any conniptions, especially about moving the include of the arch
Makefile.

I'll take another look at it tomorrow and send it out properly...

				Jeff
