Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbXGCVeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbXGCVeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757165AbXGCVeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:34:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:35385 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751754AbXGCVeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:34:08 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19LdXRShcFLkcTwfknWGpWqxLz36f9vhyTC35aI9P
	LFdoIkMXEZpaWg
Date: Tue, 3 Jul 2007 23:36:14 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: 2.6.22-rc7: known regressions with patches
Message-ID: <20070703213614.GA29175@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
	Stephane Eranian <eranian@hpl.hp.com>
References: <468A7D24.3040004@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <468A7D24.3040004@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.07.03 18:45:24 +0200, Michal Piotrowski wrote:
> Subject    : OProfile issues
> References : http://lkml.org/lkml/2007/6/12/207
> Submitter  : Stephane Eranian <eranian@hpl.hp.com>
> Handled-By : Björn Steinbrink <B.Steinbrink@gmx.de>
> Patch      : http://lkml.org/lkml/2007/6/12/392
>              http://lkml.org/lkml/2007/6/20/275
>              http://lkml.org/lkml/2007/6/20/276
> Status     : patches were suggested

Andi said that one of the regression fixes wasn't critical for .22 and
that he wants to do a stopgap for the other regression (my patch
sucked), reverting the code to the .21 version. So you can drop the
patches and/or me here.

Thanks,
Björn
