Return-Path: <linux-kernel-owner+w=401wt.eu-S1762188AbXHAGW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762188AbXHAGW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757496AbXHAGWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:22:20 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:11222 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691AbXHAGWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZggnOZ7Uzxc2GeRdjxJesctCv8T5d3v5fjfoxogeM8MMzatuUs9tYYJMaYxqT30HYRtwx3PoJGRhLBk4hLJp1M2qktYcofYv6ZuDVVntFSWsYsOII9Y5F6uy3N4MHzJKgs7RBW/Av8JD2R3j+7kk7MkIsGOmA2AiXK3SVD6AQi4=
Message-ID: <a8e1da0707312322g4559a546xc357505b591f9e65@mail.gmail.com>
Date: Wed, 1 Aug 2007 06:22:18 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Wim Van Sebroeck" <wim@iguana.be>
Subject: Re: eurotechwdt will cause reboot
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070801055845.GA2648@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0707312003s6000b02s95c90b5971dbbd51@mail.gmail.com>
	 <20070801055845.GA2648@infomag.infomag.iguana.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 8/1/07, Wim Van Sebroeck <wim@iguana.be> wrote:
> Hi Dave,
>
> > config eurotechwdt to yes will cause system silent reboot. Is it right
> > behaviour or a bug?
>
> I think this might be a bug. I'll look at the code and will ask you to do some
> tests for me (if that is ok for you).
>
I'm ok for me. BTW, the rebooting is too quick that I have to set the
boot_delay command line parameter to see it.
