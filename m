Return-Path: <linux-kernel-owner+w=401wt.eu-S1030352AbXAaR00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030352AbXAaR00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030340AbXAaR00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:26:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57147 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030352AbXAaR0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:26:25 -0500
Subject: Re: [PATCH]: mtd - fix a pci_find_device
From: David Woodhouse <dwmw2@infradead.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070131170028.3a9bef3e@localhost.localdomain>
References: <20070131170028.3a9bef3e@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 17:26:22 +0000
Message-Id: <1170264383.29759.342.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 17:00 +0000, Alan wrote:
> Going over the bugs and warnings I found this one left over. The other
> changes have already been correctly done for this driver but the actual
> switch to pci_get_device that they assume has not.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Applied; thanks.

-- 
dwmw2

