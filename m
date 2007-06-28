Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbXF1KaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbXF1KaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 06:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbXF1K3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 06:29:53 -0400
Received: from mailgw1.fraunhofer.de ([153.96.1.18]:40418 "EHLO
	mailgw1.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbXF1K3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 06:29:52 -0400
Date: Thu, 28 Jun 2007 12:27:34 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: dwmw2@infradead.org
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org,
       harald@skogtun.org, david@lang.hm
Subject: Re: Linux Kernel include files
Message-ID: <46838d16.ut8KQOMKsZ9HqPYT%Joerg.Schilling@fokus.fraunhofer.de>
References: <46826d62.lTsuVo9cC7wGjcjf%Joerg.Schilling@fokus.fraunhofer.de>
 <1182960282.1170.4.camel@pmac.infradead.org>
In-Reply-To: <1182960282.1170.4.camel@pmac.infradead.org>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Jun 2007 10:29:32.0752 (UTC) FILETIME=[37880D00:01C7B96F]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2007-06-27 at 16:00 +0200, Joerg Schilling wrote:
> > Warning: *** linux/ext2_fs.h is not usable at all ***
> > Warning: *** This makes it impossible to support Linux file flags ***
> > You may try to compile using 'make COPTX=-DTRY_EXT2_FS'
>
> Again, can you be _specific_? Amusing though your consistent 'Lunix is
> broken' chants are, the only reason I'm bothering to participate in this
> thread is on the off-chance that something _productive_ will come of it.

I have been forced to add this test as too many people reported that they
have no been able to compile star on their Linux distribution. 


> By the way, your mailer seems to be sometimes omitting In-Reply-To: and
> References: headers, which RFC2822 says you SHOULD include in replies. 

Sending such accusation without knowing the reason is not polite.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
