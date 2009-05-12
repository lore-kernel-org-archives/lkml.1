Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZELPKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZELPKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZELPKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:10:20 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:50766 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZELPKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:10:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qB1itI9VsIfCZ5rD+cPkhJ52aICMqo1W+cGSX9FYesXYvBRX98o0KyxRdDpKJPKWeT
         mbO0eJicP+o0Cj1bYrNvtdFYGgLGkaXaXj5lUgJU8m5BnH6IEQbHIZ3OktFT/sDLc4LT
         U9tZJm03kA6XK+sW2Vz22bs9B4+pdaWrKgz/M=
MIME-Version: 1.0
In-Reply-To: <20090512150622.GA10015@sgi.com>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org>
	 <20090511175312.GA27905@sgi.com>
	 <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com>
	 <4A0894A5.9000209@zytor.com>
	 <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com>
	 <20090512150622.GA10015@sgi.com>
Date: Tue, 12 May 2009 08:10:18 -0700
Message-ID: <86802c440905120810x6ea4b228t14ca19376dc13f13@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jack Steiner <steiner@sgi.com>
Cc: David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jack,

can you confirm:
1. without this patch, your system still have problem?
2. does current tip/master work for you?

YH
