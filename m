Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbXEJMtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbXEJMtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbXEJMtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:49:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:51407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbXEJMtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:49:13 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Current -git kernel kills X
References: <4641398F.5050203@garzik.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 10 May 2007 15:46:34 +0200
In-Reply-To: <4641398F.5050203@garzik.org>
Message-ID: <p736470g5ad.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> Hardware: x86-64 dual core, Intel ICH7 platform (see lspci), ATI R580
> Software: Fedora Core 6/x86-64, VESA driver, GNOME desktop, with
> latest updates

Can you try with the latest git again please? There was a fix that fixed
a similar problem for some people.

-Andi
