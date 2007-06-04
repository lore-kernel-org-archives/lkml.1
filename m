Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbXFDOlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbXFDOlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbXFDOlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:41:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:46484 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754619AbXFDOlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:41:02 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+m8/cWQMCmRzh34nTICqZAlYPzTz+6TKa/oTn25q
	+kUHd6ZtRiDyFm
Date: Mon, 4 Jun 2007 16:41:01 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Benjamin Pineau <benjamin_pineau@zouh.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3 : "BUG: scheduling while atomic: swapper/0x00000100/0"
Message-ID: <20070604144101.GB3363@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Benjamin Pineau <benjamin_pineau@zouh.org>,
	linux-kernel@vger.kernel.org
References: <20070604135514.GA14426@zouh.org> <20070604143925.GA3363@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070604143925.GA3363@atjola.homenet>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.04 16:39:25 +0200, Björn Steinbrink wrote:
> On 2007.06.04 15:55:14 +0200, Benjamin Pineau wrote:
> > lspci -vv, lspci -vn, /proc/config.gz, /proc/timer_list, lsmod,
> > /proc/interrupts, /proc/vmstat, ps auxf, and dmesg (with and 
> > without the bug's logs) outputs at
> > http://oshima.zouh.org/~ben/2.6.23-rc3_bug_details.txt
> 
> To save somebody else from guessing, that's HIRoshima, i.e. the correct
> URL is http://hiroshima.zouh.org/~ben/2.6.23-rc3_bug_details.txt

Hmpf, about a second later the original URL also started to work...

Confused,
Björn
