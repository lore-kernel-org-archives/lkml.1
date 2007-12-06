Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbXLFTNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbXLFTNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXLFTNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:13:35 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:28132 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbXLFTNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:13:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YquiYCKUtImdnpouHdh4fYHeszQfrOvt5K0jJ1gUKo4mMzSeAvxxeb6o1g+EE5DcmZaecLzdIdyQWFUkg6u2sdFHMOC01mskwgwEOwk1DYxuIIT1R+pXbMcw6rv2sbXIZEiOLQ2HCXLzMjPaG/HrTVD488m5R4YfEXpGS+2MEqA=
Message-ID: <dfb262380712061113v76626704la8e6110eaccdef40@mail.gmail.com>
Date: Thu, 6 Dec 2007 21:13:32 +0200
From: "Ramagudi Naziir" <naziirr@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: a problem with NETPOLL/KGDBoE
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       jason.wessel@windriver.com
In-Reply-To: <20071206183423.GZ19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dfb262380712061022h43eab6eaxe231b1f81f54d433@mail.gmail.com>
	 <20071206183423.GZ19691@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/6/07, Matt Mackall <mpm@selenic.com> wrote:
> On Thu, Dec 06, 2007 at 08:22:15PM +0200, Ramagudi Naziir wrote:
> > It's probably only me, but I can't connect to a kgdb host because
> > of bouncing ICMP unreachables. I'll be glad if you could take a look
...
> Hmmm, 6443 != 6433 (typo?) and 32785 != 6442 (config problem). Yes,
...

Sigh (I had both...).

Thank you, Matt, SO much (it's been a long day :).

Now everything works just great !

naziir
