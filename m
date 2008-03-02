Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYCBRNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYCBRNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 12:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYCBRNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 12:13:14 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:54424 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbYCBRNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 12:13:13 -0500
Date: Sun, 2 Mar 2008 12:13:11 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, tomof@acm.org,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 0/3] fix iommu segment boundary problems (parisc)
Message-ID: <20080302171311.GB18883@phobos.i.cabal.ca>
References: <1204438228-4564-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204438228-4564-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 03:10:25PM +0900, FUJITA Tomonori wrote:
> This patchset is another sequel to my patchset to fix iommu segment
> boundary problems, IOMMUs allocate memory areas without considering a
> low level driver's segment boundary limits:
> 
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg11919.html
> 

This looks fine. Are you able to test this? If not, we can set you up
with an account on a machine with remote console and all that jazz, if
you'd like to.

cheers, Kyle
