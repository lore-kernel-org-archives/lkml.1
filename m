Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbXBBLc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbXBBLc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 06:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbXBBLc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 06:32:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:57773 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbXBBLcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 06:32:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=L/6xNOZ8W/4TOGmkTQqpczRLDt1RBMgoMChilYbBIsyvL5uvMf2pGdl3Mfi8+21IK/N5xnIPId8dQokxxlIH7gB5Jwa5EiIHdlg6wsmdwPvxJlZarOysI/sq0/GlCwdHnJKqgOfkx4a9NzCU2rkOfj+Q84ZBHj/Lwepd6ugG6YE=
Message-ID: <84144f020702020332wee0aa69v19d09768f5643779@mail.gmail.com>
Date: Fri, 2 Feb 2007 13:32:53 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jan Dittmer" <jdi@l4x.org>
Subject: Re: [PATCH] lirc: remove backwards compatibility macro obfuscation (Was: Free Linux Driver Development!)
Cc: lirc@bartelmus.de, linux-kernel@vger.kernel.org
In-Reply-To: <45C31C19.5040200@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702021038270.21422@sbz-30.cs.Helsinki.FI>
	 <45C31C19.5040200@l4x.org>
X-Google-Sender-Auth: ade2e2152a336f9f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/07, Jan Dittmer <jdi@l4x.org> wrote:
> Pekka, it would be better if you could sort out most of the
> basic issues with lirc directly with the developers of lirc
> and then prepare a complete patch series and post that to
> lkml. Incrementally adding one driver after another. Posting
> patches to non-existent sources to lkml is pointless. First
> create a discussion base, please.

What discussion base? You need to get rid of the cruft anyway and now
you have patch to do that. I am not volunteering to sort out _all_ the
issues.
