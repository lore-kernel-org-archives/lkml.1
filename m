Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZD0LF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZD0LF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZD0LFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:05:11 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:36365 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZD0LFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:05:10 -0400
From: Karsten Keil <karsten-keil@t-online.de>
To: isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH v2 0/3] [ISDN] Documentation patchset
Date: Mon, 27 Apr 2009 13:04:39 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, tilman@imap.cc,
       i4ldeveloper@listserv.isdn4linux.de
References: <cover.1240489461.git.keil@b1-systems.de> <20090427.031323.64748515.davem@davemloft.net>
In-Reply-To: <20090427.031323.64748515.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904271304.40027.karsten-keil@t-online.de>
X-ID: Tb28iuZUghlPEpNO6OziWqgqhEXDwLIG+BtC3ko4IvbOa6wz1purCHu8J2Sjn79Z-k
X-TOI-MSGID: 0616768c-af7c-42a4-8e2a-5f86151b925e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag, 27. April 2009 12:13:23 David Miller wrote:
> From: Karsten Keil <karsten-keil@t-online.de>
> Date: Thu, 23 Apr 2009 14:24:21 +0200
>
> > Fixed one more typo and wrong From: lines.
> >
> > Add some useful documentation for the ISDN subsystem.
> > Orignal patches are from Tilman Schmidt.
> > I fixed some whitespace issues and added the URL for the CAPI 2.0 spec.
>
> This patch set does not apply at all to net-2.6

Hmm I did it against a clean Linus tree, so I assume a part from some earlier
patch is already in net-2.6, I will redo the patch against net-2.6 and send it 
to netdev only.

Karsten

