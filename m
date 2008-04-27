Return-Path: <linux-kernel-owner+w=401wt.eu-S1762386AbYD0WK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762386AbYD0WK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYD0WKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:10:17 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40861 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbYD0WKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:10:15 -0400
Subject: Re: Breakage caused by unreviewed patch in x86 tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4814F76B.8030505@zytor.com>
References: <1209329485.3801.46.camel@localhost.localdomain>
	 <4814F76B.8030505@zytor.com>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 18:10:11 -0400
Message-Id: <1209334212.3801.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-04-27 at 15:00 -0700, H. Peter Anvin wrote:
> James Bottomley wrote:
> > I might add that the intel SAPIC functions
> > in roughly the same manner, so this might break more than just voyager.
> 
> Are you referring to the IA64 SAPIC here, or something else?  The only 
> mention of SAPIC in the x86 tree appear to be naming of fields in ACPI 
> tables.

Yes, that's the one ... but I believe a class of the xAPICs also used a
similar principle.

James


