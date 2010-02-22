Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0BVTpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:45:33 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:48256 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0BVTpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:45:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cQmYDepvFUjsgdkmpjH4S/AfExetyRPz3sMOqQlTBxp4EU98Brnpt8dmd8/Dwq++Vf
         ODZO7sB+Uph9QwF3Us86V4lmgItfBf/aBs8AAyXG6cY/UavASOHDSz7ypihTrZLZ1C1o
         ALQakurIKN8X0pS1MQT84FAjNWPO5gZSdEPLA=
MIME-Version: 1.0
In-Reply-To: <20100222012735.GA8791@nowhere>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com> 
	<8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com> 
	<20100218120944.GA2406@osiris.boeblingen.de.ibm.com> <8bd0f97a1002180412x6cc4f280u5444f013c6e3b670@mail.gmail.com> 
	<20100218123453.GA5136@nowhere> <20100218132521.GB2406@osiris.boeblingen.de.ibm.com> 
	<8bd0f97a1002180601i60c5eaa4p7639091c5b617702@mail.gmail.com> 
	<20100218145055.GB855@nowhere> <4B7D68AA.8060105@redhat.com> 
	<20100222012735.GA8791@nowhere>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 22 Feb 2010 14:45:09 -0500
Message-ID: <8bd0f97a1002221145p4e8101fby66721b2b63d5c75a@mail.gmail.com>
Subject: Re: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 20:27, Frederic Weisbecker wrote:
> +         This symbol should be selected by an architecure if it supports

architecure -> architecture

otherwise, i'm placated ... thanks
-mike
