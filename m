Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYHZB4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYHZB4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 21:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbYHZB4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 21:56:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42622 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbYHZB4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 21:56:06 -0400
Date: Mon, 25 Aug 2008 19:56:05 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Airlie <airlied@linux.ie>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Samuel Ortiz <samuel@sortiz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] use lspci style for [%04x:%04x] vendor/device
Message-ID: <20080826015604.GB23698@parisc-linux.org>
References: <20080825214454.18253.82244.stgit@tigger.helgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825214454.18253.82244.stgit@tigger.helgaas>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 03:44:54PM -0600, Bjorn Helgaas wrote:
> These patches change various debug messages to use "[%04x:%04x]" for
> PCI vendor/device IDs to follow the format used by lspci(8).

Entire patchset:

Acked-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
