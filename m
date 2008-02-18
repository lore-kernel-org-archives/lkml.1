Return-Path: <linux-kernel-owner+w=401wt.eu-S1759202AbYBRL3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbYBRL3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbYBRL3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:29:07 -0500
Received: from mailgw2-out.fraunhofer.de ([153.96.1.22]:40532 "EHLO
	mailgw2-out.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125AbYBRL3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:29:06 -0500
Date: Mon, 18 Feb 2008 12:28:59 +0100
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: jengelh@computergmbh.de
Cc: schwab@suse.de, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
Message-ID: <47b96bfb.JBObZ4RAbCByCIvV%Joerg.Schilling@fokus.fraunhofer.de>
References: <47b8c177.2QDr0ADTa5ExM+/T%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0802180048320.26274@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802180048320.26274@fbirervta.pbzchgretzou.qr>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 18 Feb 2008 11:28:59.0675 (UTC) FILETIME=[74A88EB0:01C87221]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> wrote:

> >This fragment is much too short to allow to judge on possible reasons.
> >There is a high probability that your problem is caused by the cdrecord
> >fork called "wodim".
> >
> [...]
> >
> >As a general advise: if you have problems, always first try recent original 
> >software from
>
> SUSE 10.3 users (and the OP seems to be one..) may use the 'cdrtools' 
> RPM which I have in my repository (I don't like wodim either, but that's 
> not the point here). Just !webpin for cdrtools.

Thank you for this hint!

Maybe, you should mention a URL to your repository....

> (oh and please use reply-to-all/dont-strip-Ccs, thanks :)

For me too please



Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
