Return-Path: <linux-kernel-owner+w=401wt.eu-S1763391AbXHFLRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763391AbXHFLRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbXHFLRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:17:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55310 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbXHFLRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:17:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Subject: Re: Linux 2.6.23-rc2
Date: Mon, 6 Aug 2007 13:26:25 +0200
User-Agent: KMail/1.9.5
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>
References: <Pine.LNX.4.64.0708052005550.3772@boston.corp.fedex.com> <200708051847.12046.rjw@sisk.pl> <b6a2187b0708051736u74879b9cp9e638364a5b1628e@mail.gmail.com>
In-Reply-To: <b6a2187b0708051736u74879b9cp9e638364a5b1628e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061326.25888.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 August 2007 02:36, Jeff Chua wrote:
> On 8/6/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > What does 's2ram -i' say about your machine?
> 
> This machine can be identified by:
>     sys_vendor   = "LENOVO"
>     sys_product  = "1702E7A"
>     sys_version  = "ThinkPad X60s"
>     bios_version = "7BETD0WW (2.11 )"

This means it's not in the whitelist, AFAICS.

Similar machines are known to work with "--acpi_sleep=3" or with
"--acpi_sleep=1 --vbe_mode".

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
