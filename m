Return-Path: <linux-kernel-owner+w=401wt.eu-S932828AbXGRLfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbXGRLfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 07:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932637AbXGRLfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 07:35:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604AbXGRLfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 07:35:31 -0400
Message-ID: <469DFAFA.6040704@redhat.com>
Date: Wed, 18 Jul 2007 13:35:22 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
CC: Sasa Ostrouska <casaxa@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: VESAFB CUSTOM RESOLUTION
References: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com> <469CD54A.4040003@mandic.com.br>
In-Reply-To: <469CD54A.4040003@mandic.com.br>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Renato S. Yamane wrote:
> Sasa Ostrouska escreveu:
> ** Short intro for the impatient: Just use vga=ask for the first time,
> ** enter `scan' on the video mode prompt, pick the mode you want to use,
> ** remember its mode ID (the four-digit hexadecimal number) and then
> ** set the vga parameter to this number (converted to decimal first).

"scan" lists text modes only, not the graphical ones.  Now we have the
i386 boot code rewritten in C.  Should make it alot easier to add them
to the menu ...

cheers,
  Gerd
