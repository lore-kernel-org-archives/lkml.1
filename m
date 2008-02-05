Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYBERAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYBERAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:00:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbYBEQ75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:59:57 -0500
Received: from smtp116.sbc.mail.re3.yahoo.com ([66.196.96.89]:26185 "HELO
	smtp116.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752287AbYBEQ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:59:56 -0500
X-YMail-OSG: 3G7NW.4VM1nVM9RdZli26UF_DedLIgO1.gGH_49UiwvmEAgkLB3fmH6K4SUu9n7tCYMbeSK6lnCZ6LObdnX7nlGdqnvbhiKANG.4cLSvztt1v0q2pQ--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 5 Feb 2008 10:57:42 -0600
From: serge@hallyn.com
To: Markku Savela <msa@moth.iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about filesystem capability support
Message-ID: <20080205165742.GA10964@vino.hallyn.com>
References: <200802050809.m1589ILT006935@burp.tkv.asdf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802050809.m1589ILT006935@burp.tkv.asdf.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Markku Savela (msa@moth.iki.fi):
> 
> Does this filesystem capability "feature" also include the equivalent
> of "nosuid" option for a mount?

nosuid.

> (google gives gobblegook of hits with "linux file system
> capabilities", can't figure out which of them is the "definitive" one
> -- pointers?)

This is a good one: http://www.friedhoff.org/fscaps.html

thanks,
-serge
