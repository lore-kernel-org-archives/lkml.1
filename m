Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbYJQVSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbYJQVSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbYJQVSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:18:47 -0400
Received: from isilmar.linta.de ([213.133.102.198]:51016 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754168AbYJQVSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:18:47 -0400
Date: Fri, 17 Oct 2008 23:17:38 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/19] pcmcia: Whine harder about use of EXCLUSIVE
Message-ID: <20081017211738.GB18745@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org
References: <20081005163302.3799.61899.stgit@localhost.localdomain> <20081005163546.3799.95611.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005163546.3799.95611.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 05:35:59PM +0100, Alan Cox wrote:
> The exclusive IRQ line support is a legacy and any remaining drivers that
> cannot share interrupts need tidying up so whine harder about them.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Merged into pcmcia, will go upstream soon.

Best,
	Dominik
