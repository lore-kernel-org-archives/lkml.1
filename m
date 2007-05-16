Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbXEPMiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbXEPMiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759738AbXEPMiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:38:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:37654 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbXEPMiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:38:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rCBj9SoSoJJ10a8irSHMzi7ZF60OF7iOW1NAvQG8/nytkeAKZMHQE6zkrpScusPoEpG9gWgZP4eK8GJr3Kj89wQapMDaR/O9WMXYbGXceV1oaoiwtwYzzQseX8RsWRye4aL5+GZrimQGqhvRZijDH3pvLPaUiBxajYM2qeDN+wk=
Message-ID: <84144f020705160538n28f77865u37fcf15578357c35@mail.gmail.com>
Date: Wed, 16 May 2007 15:38:03 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>
Subject: Re: [PATCH] LogFS take three
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       "Albert Cahalan" <acahalan@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, "Greg KH" <greg@kroah.com>,
       "Ingo Oeser" <ioe-lkml@rameria.de>
In-Reply-To: <84144f020705160536i189f6206sffc964a145177da7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070515151919.GA32510@lazybastard.org>
	 <Pine.LNX.4.64.0705161319060.5152@sbz-30.cs.Helsinki.FI>
	 <20070516122603.GE5472@lazybastard.org>
	 <84144f020705160536i189f6206sffc964a145177da7@mail.gmail.com>
X-Google-Sender-Auth: 9e4ff27b8e88b9c2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Forgot to add (see below). Seems logfs_segment_read would be simpler
> too if you fixed this.

Blah. Just to be clear: I forgot to add a "(see below)" text in the
original review comment.
