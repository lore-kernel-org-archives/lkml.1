Return-Path: <linux-kernel-owner+w=401wt.eu-S1767048AbXDEPS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767048AbXDEPS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767047AbXDEPS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:18:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52471 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767040AbXDEPSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:18:55 -0400
Subject: Re: [PATCH v3] Stop pmac_zilog from abusing 8250's device numbers;
	optionally.
From: David Woodhouse <dwmw2@infradead.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: torben@kernel.org, paulus@samba.org, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, device@lanana.org
In-Reply-To: <20070406.000913.28784231.anemo@mba.ocn.ne.jp>
References: <1175696383.2774.24.camel@shinybook.infradead.org>
	 <20070405.233101.106261123.anemo@mba.ocn.ne.jp>
	 <1175784435.2719.18.camel@shinybook.infradead.org>
	 <20070406.000913.28784231.anemo@mba.ocn.ne.jp>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 11:18:12 -0400
Message-Id: <1175786292.2719.23.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-7.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 00:09 +0900, Atsushi Nemoto wrote:
> 
> What I did is just send a patch includeing devices.txt changes to
> lkml, device@lanana.org, and some others.
> 
> Maybe I should have sent "request" (not patch) mail to
> device@lanana.org first?

Well, that's what it says right underneath the line in devices.txt which
says:
	**** DEVICE DRIVERS AUTHORS PLEASE READ THIS ****

It goes on to say...

"Third, please don't assume that the distributed version of the list is
up to date.  Due to the number of registrations I have to maintain it
in "batch mode", so there is likely additional registrations that
haven't been listed yet."

-- 
dwmw2

