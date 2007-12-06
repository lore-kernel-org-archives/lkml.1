Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbXLFSML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbXLFSML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbXLFSL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:11:56 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38354
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751088AbXLFSLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:11:55 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: carsteno@de.ibm.com
Subject: Re: [patch] ext2: xip check fix
Date: Thu, 6 Dec 2007 12:11:48 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Nick Piggin <npiggin@suse.de>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
References: <20071204042628.GA26636@wotan.suse.de> <20071206101848.GC25202@wotan.suse.de> <4757CDD4.5090606@de.ibm.com>
In-Reply-To: <4757CDD4.5090606@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712061211.49443.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007 04:24:20 Carsten Otte wrote:
> Nick Piggin wrote:
> > OK, thanks for taking a look at that. It will be helpful for testing
> > XIP with my new ramdisk driver (did you see the patch?).
>
> I have'nt looked at it yet. I do appreciate it, I think it might
> broaden the user-base of this feature which is up to now s390 only due
> to the fact that the flash memory extensions have not been implemented
> (yet?). And it enables testing xip on other platforms. The patch is on
> my must-read list.

query: which feature is currently s390 only?  (Execute In Place?)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
