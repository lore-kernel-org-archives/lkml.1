Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbXEXMk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbXEXMk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbXEXMkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:40:15 -0400
Received: from [216.16.235.2] ([216.16.235.2]:35235 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755786AbXEXMkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:40:13 -0400
X-Originating-Ip: 99.246.112.70
Date: Thu, 24 May 2007 08:38:09 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Roland Dreier <rdreier@cisco.com>
cc: Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
In-Reply-To: <ada7iqz9qlj.fsf@cisco.com>
Message-ID: <Pine.LNX.4.64.0705240836340.4500@localhost.localdomain>
References: <200705231510.52932.rob@landley.net> <46549937.1030306@linux.intel.com>
 <20070523212237.GH2098@stusta.de> <ada7iqz9qlj.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Roland Dreier wrote:

>  > - every static function in a header file must be __always_inline
>
> Why?  Why does it matter whether a function is defined in a .h file or
> a .c file?  Can't the compiler decide better than we can whether
> something should be inlined or not?
>
> Your argument seems to imply that we should never use the inline
> keyword at all.

i hate to be in the middle of one of these again, but i think i
initiated this topic way back when when i (like rob landley) asked why
that config option was still around when it's been listed for deletion
for a year.

regardless of its good or bad points, one way or the other, something
should be updated.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
