Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYJQJ3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYJQJ3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 05:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYJQJ3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 05:29:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32995 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751666AbYJQJ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 05:29:09 -0400
Date: Fri, 17 Oct 2008 10:28:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: n0ano@n0ano.com
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, donald.d.dugger@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081017102858.1f1d77f7@lxorguk.ukuu.org.uk>
In-Reply-To: <20081017023912.GA9378@xolotl.n0ano.com>
References: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com>
	<200810161716.47620.bjorn.helgaas@hp.com>
	<20081017023912.GA9378@xolotl.n0ano.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We're arguing now about what to do about the `earlycon' and `earlyprintk'
> parameters, I contend we should remove those as the `console=uart' is
> a superset of their capabilities but there are some dissenting opinions.

Different discussion and different patches. We can get patches in for the
crystal frequency stuff and then debate the rest later
