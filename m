Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbYILRl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbYILRl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYILRkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:40:12 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:14343 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362AbYILRkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:40:10 -0400
X-BigFish: VPS-31(z21eW34a4lz98dR936fQ3117Kzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K73FQF-01-09E-01
Date: Fri, 12 Sep 2008 19:39:33 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Rufus & Azrael <rufus-azrael@numericable.fr>,
       Jordan Crouse <jordan.crouse@amd.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user
	with the same regression
Message-ID: <20080912173933.GF6743@alberich.amd.com>
References: <86802c440808231217q3eebc738v863170b178bb03ab@mail.gmail.com> <48B067B3.6020008@numericable.fr> <86802c440808231310hdafc30aw6931b77ea926338e@mail.gmail.com> <48B06FF9.1030404@numericable.fr> <86802c440808231328w5c6a3fa3s9be9d90ec1f30aa1@mail.gmail.com> <48B07409.60905@numericable.fr> <86802c440808231335n9214e38q5141a3560c698f76@mail.gmail.com> <48B074E1.9020106@numericable.fr> <86802c440808231345u7c4f7710k5878928239507b10@mail.gmail.com> <86802c440808231405u42fa8024r89eccc907f36d99e@mail.gmail
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86802c440808231405u42fa8024r89eccc907f36d99e@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Sep 2008 17:39:56.0730 (UTC) FILETIME=[9267E1A0:01C914FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 02:05:19PM -0700, Yinghai Lu wrote:
> Jordan, or others for AMD could access SB600
> can you check ATI SB600 doc to produce one quirks patch to set the
> magic bit to hide 00:14.0 BAR1 to OS ?

I know this is a very late reply, but
is there still a quirk desired to hide BAR1 of SB600 SMBus device?

If yes, I'll provide a patch asap.


Regards,

Andreas




