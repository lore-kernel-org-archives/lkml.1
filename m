Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbYD3D3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbYD3D3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 23:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYD3D3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 23:29:42 -0400
Received: from qb-out-0506.google.com ([72.14.204.231]:19934 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbYD3D3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 23:29:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XRHO10fCAqfSW4tq+svPEL/e6a2P7J/NCTPuPt/WmKnHk+avRocP4NJKLHXyMAXH64S3ueuwmZ2CaRKFg5yww5Hc5eXBTXWXcTWZRzlL+JuIVsWWgbYzHY6Gg66KGAdtuPScuFdVwbiDdHzyG0X+8DkvLRsQSmm0wxJIC4Ldkl0=
Message-ID: <86802c440804292029y4a22e322s54220923f32f283f@mail.gmail.com>
Date: Tue, 29 Apr 2008 20:29:39 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [PATCH 1/2] x86: mtrr cleanup for converting continuous to discrete layout v7
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440804292000j1b559bc2y8281fa1608d8e4af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <48170BDB.9000801@googlemail.com>
	 <86802c440804291011g1cdd2c81h962f066dd7980282@mail.gmail.com>
	 <48178434.90701@googlemail.com>
	 <86802c440804291449y50f178a6x4e200c26840493a@mail.gmail.com>
	 <4817B5B0.5090606@googlemail.com> <4817B811.9070707@googlemail.com>
	 <86802c440804291738p401e339djda18d24bce324795@mail.gmail.com>
	 <4817C52A.8000000@googlemail.com>
	 <86802c440804292000j1b559bc2y8281fa1608d8e4af@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please try the patches

from
http://lkml.org/lkml/2008/4/29/754
http://lkml.org/lkml/2008/4/29/753

in addtion to

http://people.redhat.com/mingo/x86.git/README
( it has v8 already)

and try with mtrr_gran_size=128m

Thanks

YH
