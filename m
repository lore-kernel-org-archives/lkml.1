Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbXDEPtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbXDEPtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXDEPtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:49:43 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:51853 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbXDEPtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:49:42 -0400
Date: Fri, 06 Apr 2007 00:49:39 +0900 (JST)
Message-Id: <20070406.004939.89276671.anemo@mba.ocn.ne.jp>
To: dwmw2@infradead.org
Cc: torben@kernel.org, paulus@samba.org, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, device@lanana.org
Subject: Re: [PATCH v3] Stop pmac_zilog from abusing 8250's device numbers;
 optionally.
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1175786292.2719.23.camel@shinybook.infradead.org>
References: <1175784435.2719.18.camel@shinybook.infradead.org>
	<20070406.000913.28784231.anemo@mba.ocn.ne.jp>
	<1175786292.2719.23.camel@shinybook.infradead.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 11:18:12 -0400, David Woodhouse <dwmw2@infradead.org> wrote:
> > Maybe I should have sent "request" (not patch) mail to
> > device@lanana.org first?
> 
> Well, that's what it says right underneath the line in devices.txt which
> says:
> 	**** DEVICE DRIVERS AUTHORS PLEASE READ THIS ****
> 
> It goes on to say...
> 
> "Third, please don't assume that the distributed version of the list is
> up to date.  Due to the number of registrations I have to maintain it
> in "batch mode", so there is likely additional registrations that
> haven't been listed yet."

Thank you, I see.  I'll revoke the patch in -mm tree and send a
request for minor numbers.

---
Atsushi Nemoto
