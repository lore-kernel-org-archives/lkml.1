Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbXLUBns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbXLUBns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXLUBnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:43:40 -0500
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:58712 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078AbXLUBnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:43:39 -0500
From: Frans Pop <elendil@planet.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Trailing periods in kernel messages
Date: Fri, 21 Dec 2007 02:43:33 +0100
User-Agent: KMail/1.9.7
Cc: Andy Whitcroft <apw@shadowen.org>, Joe Perches <joe@perches.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
References: <474E6BD0.20103@cn.fujitsu.com> <20071220162923.GB27885@shadowen.org> <20071220210741.6dc3caf5@the-village.bc.nu>
In-Reply-To: <20071220210741.6dc3caf5@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712210243.35240.elendil@planet.nl>
X-OriginalArrivalTime: 21 Dec 2007 01:43:36.0060 (UTC) FILETIME=[E6FAFBC0:01C84372]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007, Alan Cox wrote:
> The kernel printk messages are sentences.

I'm afraid that I completely and utterly disagree. Kernel messages are _not_ 
sentences. The vast majority is not well-formed and does not contain any of 
the elements that are required for a proper sentence.

The most kernel messages can be compared to is a rather diverse and sloppy 
enumeration. And enumerations follow completely different rules than 
sentences. It can better be characterized as a "semi-random sequence of 
context-sensitive technical messages".

IMHO the existing rule that "Kernel messages do not have to be terminated 
with a period." is completely justified, though it does need some minor 
clarification on the cases in which proper punctuation _should_ be 
followed.
