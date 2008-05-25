Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbYEYNIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbYEYNIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYEYNIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:08:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:57131 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbYEYNIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:08:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Bx+xtVTH4RunnYt3i9GPVchmzWrTK0xE1ZIBdc0F2DgZ/AE53EKdNrtDV6IFsc4ASWhuzDP7wxFdh4QHfs0Ihv389jVaeXXFaq6//wLvveDqgaXBKikE22cwQRyVP0CBbznFODMIg/v8Y1VNtzLqlUqBWa2bI7Z6BFnpPx37VT8=
Message-ID: <7b9198260805250608i3b30d0ccg2dcb818c202b8e22@mail.gmail.com>
Date: Sun, 25 May 2008 14:08:10 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Gene Heskett" <gene.heskett@verizon.net>
Subject: Re: Something odd in knail from 3.5.9 on F8
Cc: kdepim-users@kde.org, linux-kernel@vger.kernel.org
In-Reply-To: <200805250750.31491.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805250750.31491.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/25 Gene Heskett <gene.heskett@verizon.net>:
> Greetings all;
>
> Yesterday I needed to email a patch file I had just generated to the maintainer
> of the OS for a "legacy" computer, so I fired up the new mail by clicking on
> his name in a previous email, wrote a short msg and tried to attach the patch.
> But regardless of how many times I backed out of the directory & then went back
> in, the directory listing I was being shown was exactly as it had existed about
> 36 hours ago.  No new files could be seen.  So I could not attach it, nor
> include it as text in that msg.
> .
> After I had sent the msg, I shut kmail down using its quit button, gave it 30
> secs to clean up and disappear from the htop list, then restarted it, at which
> point the newer and missing files were then visible and I sent the patch using
> the exact same procedure.
>
> Currently running locally built 2.6.26-rc2 for a kernel.  So which direction do
> I point the accusatory finger here folks?

Hi Gene,

Are you able to reproduce the problem?  Were you able to view the
"real" contents of the directory in, say, a terminal (with ls) or
Konqueror (or whatever you prefer), while KMail was acting up?

> Cheers, Gene

-- 
Tom Spink
