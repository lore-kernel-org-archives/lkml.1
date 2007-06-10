Return-Path: <linux-kernel-owner+w=401wt.eu-S1762487AbXFJWJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762487AbXFJWJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 18:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbXFJWJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 18:09:04 -0400
Received: from waste.org ([66.93.16.53]:38563 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617AbXFJWJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 18:09:01 -0400
Date: Sun, 10 Jun 2007 17:08:46 -0500
From: Matt Mackall <mpm@selenic.com>
To: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, m-ikeda@ds.jp.nec.com
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
Message-ID: <20070610220846.GF11166@waste.org>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070610.204845.115909592.tshibata@ab.jp.nec.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2007 at 08:48:45PM +0900, Tsugikazu Shibata wrote:
> Hi all,
> 
> I am posting Documentation/HOWTO which is translated into Japanese at
> bottom of this email.
> This document had been reviewed by JF project which has long history
> to translate documents into Japanese. (not only kernel but also FAQs).
> For JF, please see : http://www.linux.or.jp/JF/index.html
> Please also note that the page is written in Japanese, but you can see
> a lot of results there.
> 
> Actually, this is my first trial to post Japanese translated document
> and here are some points I decided ;
> 
> - Character encoding is ISO-2022-JP, which is normally used for email
>   using Japanese.
> - Added "Singed-off-by" line
> - Left the JF header strings which include translator/reviewer's name
> - Non-patch format, simple text
> 
> I would be happy if I could get your comments and suggestions.
> Though I know there are several issues to merge it, I want to have 
> discussions with you to accomplish it.
> 
> This email comes from strong recommendation from Greg K-H when he came
> to Tokyo two weeks ago. Thanks >Greg

This is a great idea, thanks.

What I'm not clear on is where this is intended to go?

The below isn't a patch, so if it's intended to live on a website
rather than in the kernel tarball, great. We probably want a link from
the in-kernel HOWTO to that website.

If it is intended to live in the kernel tarball, I'm not sure that's a
good idea. There are a number of languages we could consider
translating these and other documents into.

-- 
Mathematics is the supreme nostalgia of our time.
