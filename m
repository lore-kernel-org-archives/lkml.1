Return-Path: <linux-kernel-owner+w=401wt.eu-S1760811AbXJMBWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811AbXJMBWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 21:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbXJMBWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 21:22:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33304 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbXJMBWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 21:22:08 -0400
Message-ID: <47101D9E.1090700@zytor.com>
Date: Fri, 12 Oct 2007 18:21:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Correct filenames in comments.
References: <20071013004332.GA18760@redhat.com>
In-Reply-To: <20071013004332.GA18760@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> I never really understood the motivation behind putting the filename
> in a comment, but this fixes up a bunch of them that are now wrong
> post-merge.

Presumably it is there just in case you print them out with lpr instead 
of enscript, or if your editor doesn't tell you the filename.

	-hpa
