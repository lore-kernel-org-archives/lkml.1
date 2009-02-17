Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZBQVDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZBQVDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZBQVDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:03:17 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:36957 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZBQVDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:03:17 -0500
Date: Tue, 17 Feb 2009 22:03:16 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Alain Knaff <alain@knaff.lu>, the arch/x86 maintainers <x86@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
In-Reply-To: <49614D1F.8020900@zytor.com>
Message-ID: <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr>
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2009-01-05 00:58, H. Peter Anvin wrote:
>
>I have pulled the x86 parts of the bzip2/lzma patchset into
>tip:x86/setup-lzma.  I would appreciate it if you could look at it and
>make sure it looks sane.  I have not added the ARM portions (patch 4),
>since those should go via the ARM tree, nor the capstone patch 5, which
>can only be added after the old code is removed from *all* remaining
>architectures.

It seems to work well here. It would be cool if this finds its way
into mainline sometime.
