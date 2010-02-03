Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab0BCQvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:51:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38287 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab0BCQvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:51:47 -0500
X-Authority-Analysis: v=1.0 c=1 a=NqJWMTIrbqwA:10 a=7U3hwN5JcxgA:10 a=vQttewqkFmRVi5oX4ZEA:9 a=TjGTlgmidi0-NBWTg15Qvq3XUkAA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/3] kernel-shark: fix unitialized handle compile
 warnings
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: John Kacur <jkacur@gmail.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <520f0cf11002030842m6fd73d48j547551169bbc4f6e@mail.gmail.com>
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
	 <1265043026-24987-4-git-send-email-dvhltc@us.ibm.com>
	 <520f0cf11002030805q35029925u36f544f7d37faedb@mail.gmail.com>
	 <1265213851.24386.1.camel@gandalf.stny.rr.com>
	 <1265213945.24386.2.camel@gandalf.stny.rr.com>
	 <520f0cf11002030842m6fd73d48j547551169bbc4f6e@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Feb 2010 11:51:44 -0500
Message-ID: <1265215904.24386.6.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 17:42 +0100, John Kacur wrote:

> 
> Okay, are you going to push it to your repo for us? I would offer to
> push it through mine if it would save you time, but it's probably
> quicker if you just handle it.

Yeah, I'll pull via email the one patch and then do this one by hand.

-- Steve


