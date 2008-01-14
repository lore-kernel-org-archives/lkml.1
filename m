Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbYANTUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbYANTUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYANTT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:19:57 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:10256 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYANTT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:19:56 -0500
Subject: Re: [PATCH] checkpatch.pl: show how to read from stdin
From: Daniel Walker <dwalker@mvista.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bernd Petrovitsch <bernd@firmix.at>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20080114191243.GB25058@shadowen.org>
References: <47873505.7040008@gmail.com>
	 <1200043399.3905.9.camel@gimli.at.home>
	 <1200043827.29897.70.camel@imap.mvista.com> <47873833.30001@gmail.com>
	 <1200044206.29897.73.camel@imap.mvista.com>
	 <4787502B.2020606@s5r6.in-berlin.de> <47875809.7060301@gmail.com>
	 <tkrat.b5ac0cacd128569b@s5r6.in-berlin.de>
	 <20080114171736.GC19327@shadowen.org>
	 <1200332116.31521.3.camel@imap.mvista.com>
	 <20080114191243.GB25058@shadowen.org>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 11:17:22 -0800
Message-Id: <1200338243.31521.10.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 19:12 +0000, Andy Whitcroft wrote:
> So it does, however that of itself differs from the unix norm; as with
> this I cannot run checkpatch and "type" (ie paste) a patch fragment to
> check it.  So I don't think we want the semantics as you have there,
> as its confusing to the experienced user and inconsistent with the
> norm.
> Either we should document the standard '-' usage as has been suggested
> elsewhere or always assume stdin with no parameters.

I'm not sure I understand what you mean .. Can you give an example?

Daniel

