Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbYKRQrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbYKRQrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYKRQro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:47:44 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:28104 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYKRQro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:47:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j2ZvUo7yyP8O0dhDNWmaH4Tjy/I6UgIHcTFtt1Thpx+dMNTxeuB3Zr4TsGG2urdwTg
         4UEez35+gnpA+T085n9TKtrkGacD3ZBWP/+dSGxdB4yQignP44CRFDyzU3sbztU9VMTm
         DCSeL9D5L6ftZeebHOB9F532AEXJTc6lN/FdY=
Message-ID: <c62985530811180847w30f5724dvb6dff8fd7f4913de@mail.gmail.com>
Date: Tue, 18 Nov 2008 17:47:42 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun field
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081118164019.GA18620@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081117084923.GD28786@elte.hu> <20081118084755.GK17838@elte.hu>
	 <alpine.DEB.1.10.0811180922370.15003@gandalf.stny.rr.com>
	 <20081118145154.GC30358@elte.hu>
	 <alpine.DEB.1.10.0811181006010.15003@gandalf.stny.rr.com>
	 <20081118151326.GH30358@elte.hu>
	 <alpine.DEB.1.10.0811181020350.15003@gandalf.stny.rr.com>
	 <20081118155045.GJ30358@elte.hu>
	 <c62985530811180831n132ed6dep77aa2684ff59861@mail.gmail.com>
	 <20081118164019.GA18620@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/18 Ingo Molnar <mingo@elte.hu>:
> Would be nice to have the dynamic allocation straight away

2008/11/18 Steven Rostedt <rostedt@goodmis.org>:
> I would recommend using a static array

:-)
