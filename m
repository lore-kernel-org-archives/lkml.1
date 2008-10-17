Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYJQVTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYJQVTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 17:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYJQVSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 17:18:49 -0400
Received: from isilmar.linta.de ([213.133.102.198]:51018 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754204AbYJQVSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 17:18:47 -0400
Date: Fri, 17 Oct 2008 23:18:31 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/19] fdomain_cs: Sort out modules with duplicate
	description
Message-ID: <20081017211831.GC18745@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org
References: <20081005163302.3799.61899.stgit@localhost.localdomain> <20081005163913.3799.50660.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005163913.3799.50660.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 	05, 2008 at 05:39:16PM +0100, Alan Cox wrote:
> The PCMCIA one provides its own description so in PCMCIA mode we should use
> that.

Merged into pcmcia, will push upstream soon.

Best,
	Dominik
