Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbZAEDxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbZAEDxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 22:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZAEDw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 22:52:59 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58942
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZAEDw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 22:52:59 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: david@lang.hm
Subject: Re: document ext3 requirements
Date: Sun, 4 Jan 2009 21:52:36 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <fa.P4z5CJpM0xT37PWJuOuCHDkO76o@ifi.uio.no> <200901042051.14269.rob@landley.net> <alpine.DEB.1.10.0901041955360.25545@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.10.0901041955360.25545@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042152.37133.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009 22:02:05 david@lang.hm wrote:
> when I asked about the on the md list a couple of years ago, the response
> that I got was that it was a good idea, but there was no way to get the
> information about the low-level topology to the higher levels that would
> need to act on the information.

Mount option or an argument to mkfs that stores it in the superblock both work 
for me.

> now that there is a second case where this
> is needed, any mechanism that gets created should be made so that it's
> useable for both.

The embedded and supercomputing worlds have more in common with each other 
than either does with the desktop...

> David Lang

Rob
