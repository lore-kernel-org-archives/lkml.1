Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbXJBCyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbXJBCyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 22:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXJBCx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 22:53:59 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:34229
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751723AbXJBCx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 22:53:58 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Remove nonstandard line break from Documentation/powerpc/00-INDEX
Date: Mon, 1 Oct 2007 21:53:54 -0500
User-Agent: KMail/1.9.6
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200709281925.28532.rob@landley.net>
In-Reply-To: <200709281925.28532.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710012153.54794.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2007 7:25:28 pm Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
>
> Remove nonstandard line break from Documentation/powerpc/00-INDEX
>
> Signed-off-by: Rob Landley <rob@landley.net>
> ---
>
> This is the only instance of a newline in a 00-INDEX file description, and
> it confuses my 00-INDEX > index.html converter.

Turns out it's not the only instance, there's a second one in 
Documentation/networking.  I adjusted my script to work with multiline 
00-INDEX entries, I've dropped this patch from my pending heap (which is 
still online at http://landley.net/kdocs/make/patches ).

Thanks,

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
