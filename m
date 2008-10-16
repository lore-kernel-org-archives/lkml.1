Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbYJPHJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbYJPHJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 03:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYJPHJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 03:09:13 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:44490 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYJPHJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 03:09:12 -0400
Date: Thu, 16 Oct 2008 09:09:07 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hans Schou <linux@schou.dk>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SiS55x, another x86 CPU
In-Reply-To: <Pine.LNX.4.64.0810160027150.7873@sko.w0.dk>
Message-ID: <Pine.LNX.4.64.0810160907330.25933@anakin>
References: <Pine.LNX.4.64.0810111143210.23344@sko.w0.dk> <87d4i5rq7i.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0810132240010.8901@sko.w0.dk> <20081014060616.GO12131@one.firstfloor.org>
 <Pine.LNX.4.64.0810140828220.11184@sko.w0.dk> <20081015100637.GS12131@one.firstfloor.org>
 <Pine.LNX.4.64.0810152150070.25933@anakin> <Pine.LNX.4.64.0810160027150.7873@sko.w0.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, Hans Schou wrote:
> On Wed, 15 Oct 2008, Geert Uytterhoeven wrote:
> > On Wed, 15 Oct 2008, Andi Kleen wrote:
> > > > If any CR/LF in your file you must have added them yourself.
> > > 
> > > There were definitely CR/LFs in the patch attachment you sent.
> > > And no my mailer doesn't add them.
> > 
> > Interesting. I didn't see any CR/LFs neither, after exporting the
> > attachment to a file (I'm using pine).
> 
> As far as I could see, Pine does this:
> 
> 1. If file has not extension like: .zip .jpg .exe, see it as ASCII
> 2. Add CR/LF to the file
> 3. Encode file as base64
> 
> On reception of the file:
> 
> 1. Decode file as specified (in this case base64)
> 2. If it looks like a text file, convert CR/LF to LF.
> 
> > However, when doing a base64 decode on the raw attachment data, the
> > CR/LFs did pop up.
> 
> I think time is up for getting rid of Pine and there stupid license. I'll
> check if "nail" can handle attachment correctly.

alpine?

But, why do you send patches as attachments in the first place?
It's recommended to _not_ do that, for easier review.
Pine can handle that fine since ages (I switched from elm to pine 13 or
so years ago).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
