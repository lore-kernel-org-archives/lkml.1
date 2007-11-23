Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbXKWKcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbXKWKcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXKWKcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:32:04 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:44778 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbXKWKcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:32:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=IBj0XqDUDZT6RwWnDi3csxZg8H+NxOctEdEpYlBPSGW3BHrxp0Rter86XpERxm1snuZqu+PiqEDJO5NdMX30D4b/Jd1xpDOgYRJh1OVKLG3SuxDn5By3t0C1J/s8oq2PPzzzc65FW8pYbxvf61mThzyg25pWRZ3B/IpEdJ3yf9g=
Message-ID: <84144f020711230232s5adf92c8if2b05d18a8585945@mail.gmail.com>
Date: Fri, 23 Nov 2007 12:32:01 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "WANG Cong" <xiyou.wangcong@gmail.com>
Subject: Re: [PROBLEM] uml doesn't compile on i386
Cc: "Jeff Dike" <jdike@addtoit.com>, Blaisorblade <blaisorblade@yahoo.it>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071123101348.GC2488@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <84144f020711230052h2d0b8af8radbdf1d7b08a57e3@mail.gmail.com>
	 <20071123101348.GC2488@hacking>
X-Google-Sender-Auth: 18b8b429fc44ec7a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 23, 2007 at 10:52:06AM +0200, Pekka Enberg wrote:
> > Current git head doesn't compile. Looks like fall-out from the x86 merge?

On Nov 23, 2007 12:13 PM, WANG Cong <xiyou.wangcong@gmail.com> wrote:
> Hmm, I believe this patch[1] from Jeff can solve the problem. ;-)
>
> [1] http://lkml.org/lkml/2007/11/19/220

Thanks! Jeff, can we get this into mainline, please?
