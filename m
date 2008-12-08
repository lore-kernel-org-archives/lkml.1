Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYLHQfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYLHQfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 11:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYLHQfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 11:35:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:55830 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbYLHQfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:35:12 -0500
Date: Mon, 8 Dec 2008 16:35:05 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yves-Alexis Perez <corsac@debian.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12152] Huge wakeups number from i1915
Message-ID: <20081208163505.GB2496@srcf.ucam.org>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera> <20081207151203.46c01a0d@infradead.org> <1228717448.9677.3.camel@hidalgo> <200812080828.07683.rjw@sisk.pl> <20081208125938.GB31976@srcf.ucam.org> <20081208161948.GF16053@corsac.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081208161948.GF16053@corsac.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 05:19:49PM +0100, Yves-Alexis Perez wrote:
> > Doesn't ring any bells for me...
> 
> This was the “irq spinning” thread on dri-devel.

Looks like the patch was from Keith, not me?

Unrelatedly, I didn't get the Cc:ed copy of this mail. Did you get a 
bounce?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
