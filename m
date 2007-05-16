Return-Path: <linux-kernel-owner+w=401wt.eu-S1763229AbXEPR5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763229AbXEPR5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXEPR5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:57:09 -0400
Received: from terminus.zytor.com ([192.83.249.54]:33618 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbXEPR5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:57:08 -0400
Message-ID: <464B458C.1030805@zytor.com>
Date: Wed, 16 May 2007 10:55:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Mel Gorman <mel@skynet.ie>
CC: Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com> <20070516174046.GE10225@skynet.ie>
In-Reply-To: <20070516174046.GE10225@skynet.ie>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (16/05/07 08:16), H. Peter Anvin didst pronounce:
>> Andy Whitcroft wrote:
>>> Getting this on both x86 and x86_64 boxes, they are the older boxen so
>>> likely older compilers:
>> Please give the gcc version number.
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

... as well as binutils version number (it appears that your version of
ld doesn't support the "ASSERT" statement?)

> ld:arch/i386/boot/setup.ld:47: syntax error
> make[1]: *** [arch/i386/boot/setup.elf] Error 1

	-hpa
