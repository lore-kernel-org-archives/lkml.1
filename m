Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423Ab0ASI3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab0ASI3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385Ab0ASI3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:29:22 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:26553 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab0ASI3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:29:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FH56aVFBZin1V4djvBPf0flm/hhMntnYJkxzMTq0pgY7wuT43ULit4QfOdPnvSHv8K
         vT7TVBYxogDgCYnxfjNR7sqqGlr7+Rrlpxu+LJRI/NnlMnjaMuKFKuiP5ZzRjvh+8jQH
         idNacBpId8N2RVeyFpizrFmxSlQzXnqFZnqg4=
Subject: Re: linux-next: backlight tree build warning
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100119150836.bb975e4b.sfr@canb.auug.org.au>
References: <20100119150836.bb975e4b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 09:29:17 +0100
Message-ID: <1263889757.3121.10.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mar, 2010-01-19 at 15:08 +1100, Stephen Rothwell wrote:
> Hi Richard,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> WARNING: modpost: missing MODULE_LICENSE() in drivers/video/backlight/l4f00242t03.o
> 
> Introduced by commit 1bb615b563230e690b332dae4fda0067c2f88bbc
> ("backlight: Add Epson L4F00242T03 LCD driver").
> 

Mm I don't know what it goes wrong but metadata of that patch indicate
to create the file l4f00242t03.c with one line less (the module licence).
Sorry me, surely is my fault.

Fixing patch in response..

Alberto!

