Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYJQVTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYJQVTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbYJQVSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:18:48 -0400
Received: from isilmar.linta.de ([213.133.102.198]:51017 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754203AbYJQVSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:18:47 -0400
Date: Fri, 17 Oct 2008 23:17:14 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/19] pcmcia: IRQ_TYPE_EXCLUSIVE is long obsoleted
Message-ID: <20081017211714.GA18745@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Marcel Holtmann <marcel@holtmann.org>, Alan Cox <alan@redhat.com>,
	linux-kernel@vger.kernel.org
References: <20081005163302.3799.61899.stgit@localhost.localdomain> <20081005163526.3799.57100.stgit@localhost.localdomain> <1223224831.11272.107.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223224831.11272.107.camel@violet.holtmann.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan, Marcel,

On Sun, Oct 05, 2008 at 06:40:31PM +0200, Marcel Holtmann wrote:
> > Switch more drivers to dynamic sharing after checking their IRQ handlers
> > use dev_id and are robust
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> Acked-by: Marcel Holtmann <marcel@holtmann.org>

Merged into pcmcia , will push upstream within a few days.

Best,
	Dominik
