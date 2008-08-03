Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbYHCUXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbYHCUXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 16:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbYHCUXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 16:23:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbYHCUXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 16:23:33 -0400
Subject: Re: [Ksummit-2008-discuss] Kernel Summit request for Discussion of
	future of ATA (libata) and IDE
From: David Woodhouse <dwmw2@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Willy Tarreau <w@1wt.eu>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <200808031945.04160.rjw@sisk.pl>
References: <1217779055.4179.10.camel@localhost.localdomain>
	 <20080803173941.314edf33@lxorguk.ukuu.org.uk> <20080803173254.GI615@1wt.eu>
	 <200808031945.04160.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 03 Aug 2008 21:22:54 +0100
Message-Id: <1217794974.2500.15.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-03 at 19:45 +0200, Rafael J. Wysocki wrote:
> Well, I know of at least one case of PC hardware in which an old IDE driver
> basically works while the libata/pata poeple have no idea why their driver
> doesn't:

I have one of those too (pdc202xx craps itself with the new drivers).

-- 
dwmw2

