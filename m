Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbXJGXdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbXJGXdv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 19:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbXJGXdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 19:33:43 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:57594 "EHLO
	smtp1.bethere.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbXJGXdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 19:33:43 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:' usage"
Date: Mon, 8 Oct 2007 00:33:41 +0100
User-Agent: KMail/1.9.7
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Oleg Verych <olecom@flower.upol.cz>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <200710072340.40828.alistair@devzero.co.uk> <47096752.2070107@keyaccess.nl>
In-Reply-To: <47096752.2070107@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710080033.41502.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 October 2007 00:10:10 Rene Herman wrote:
> I find Alan's suggestion to provide the functionality the same way you'd
> provide for translated kernel messages (seeing as how there also are people
> that want those) much more sensible.

By the way, I agree that this is the best approach. Feasibly, it could be used 
by the same splash engines you mention to colour their console redirect, 
though most of the engines I've seen (e.g. SuSE/Ubuntu) don't let you switch 
messages on until after init (at which point kernel colours are probably 
irrelevant).

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
