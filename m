Return-Path: <linux-kernel-owner+w=401wt.eu-S965343AbXBTQNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343AbXBTQNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030189AbXBTQNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:13:35 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2521 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965350AbXBTQNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:13:30 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
Date: Tue, 20 Feb 2007 17:14:41 +0100
User-Agent: KMail/1.9.5
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6> <200702201629.40758.m.kozlowski@tuxland.pl> <014B4DC2-53BB-423E-B261-569299CAB2D9@kernel.crashing.org>
In-Reply-To: <014B4DC2-53BB-423E-B261-569299CAB2D9@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702201714.41300.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > Please fix the parentheses thing in both arch/powerpc/mm/ 
> > pgtable_32.c and
> > arch/ppc/mm/pgtable.c.
> >
> >> +#define is_power_of_4(x)	is_power_of_2(x) && (ffs(x) & 1))
> 
> These should be fixed and pushed upstream by now.

Great. Thanks.

Regards,

	Mariusz Kozlowski
