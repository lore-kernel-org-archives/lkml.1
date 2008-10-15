Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYJOTxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYJOTxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbYJOTwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:52:01 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:39488 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbYJOTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:52:00 -0400
Date: Wed, 15 Oct 2008 21:51:57 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Hans Schou <linux@schou.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SiS55x, another x86 CPU
In-Reply-To: <20081015100637.GS12131@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0810152150070.25933@anakin>
References: <Pine.LNX.4.64.0810111143210.23344@sko.w0.dk> <87d4i5rq7i.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0810132240010.8901@sko.w0.dk> <20081014060616.GO12131@one.firstfloor.org>
 <Pine.LNX.4.64.0810140828220.11184@sko.w0.dk> <20081015100637.GS12131@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Andi Kleen wrote:
> > If any CR/LF in your file you must have added them yourself.
> 
> There were definitely CR/LFs in the patch attachment you sent.
> And no my mailer doesn't add them.

Interesting. I didn't see any CR/LFs neither, after exporting the
attachment to a file (I'm using pine).

However, when doing a base64 decode on the raw attachment data, the
CR/LFs did pop up.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
