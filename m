Return-Path: <linux-kernel-owner+w=401wt.eu-S938140AbXHMTx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938140AbXHMTx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbXHMTxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:53:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:39379 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbXHMTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:52:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rdNV1dz9ZSI07TnqZFsCoffW1Qn+kBGFGE1TmYZKW8GUdYtpKg/jVpdxS7tzZrwJzDoeIV+VDNLFx24GoyvSDcWaOKHBaz8oSYJnlpfTB8r0THvW2GorBvHEgItD6utzhUhUbSReb9zcuSHY1l13GYc/2XThRwwhR9GUdlsdzNk=
Message-ID: <46C0B6C9.8000107@gmail.com>
Date: Mon, 13 Aug 2007 21:53:45 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [324/2many] MAINTAINERS - MOXA SMARTIO/INDUSTIO SERIAL
 CARD (MXSER 2.0)
References: <46bffaed.zgG/64zMGWFNDCEO%joe@perches.com>	 <46C0B235.1030302@gmail.com> <1187033981.10249.275.camel@localhost>
In-Reply-To: <1187033981.10249.275.camel@localhost>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches napsal(a):
> On Mon, 2007-08-13 at 21:34 +0200, Jiri Slaby wrote:
>> Only mxser_new.*
> 
> MOXA SMARTIO/INDUSTIO SERIAL CARD (MXSER 2.0)
> P:	Jiri Slaby
> M:	jirislaby@gmail.com
> L:	linux-kernel@vger.kernel.org
> S:	Maintained
> F:	Documentation/moxa-smartio
> F:	drivers/char/moxa.c
> F:	drivers/char/mxser_new.*

No, only mxser_new.*

moxa.c is MOXA INTELLIO

The Documentation file is a little bit obsolete (and doesn't fit to mxser_new
too much, but OK, it doesn't matter)...


-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
