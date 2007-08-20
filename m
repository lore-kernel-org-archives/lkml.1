Return-Path: <linux-kernel-owner+w=401wt.eu-S1761730AbXHTXhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761730AbXHTXhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXHTXg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:36:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56517 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750841AbXHTXgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:36:55 -0400
Date: Mon, 20 Aug 2007 16:36:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Julian Calaby <julian.calaby@gmail.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, wli@holomorphy.com
Subject: Re: [patch 21/23] Add cmpxchg_local to sparc64
In-Reply-To: <646765f40708201634u5437f307l8259456c92af5cf5@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708201636260.32662@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca>  <20070820201831.178200926@polymtl.ca>
 <646765f40708201634u5437f307l8259456c92af5cf5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Julian Calaby wrote:

> >    })
> >
> > +#include <asm-generic/cmpxchg-local.h>
> 
> Shouldn't #includes go at the start of the file?

Most of the timee but there are exceptions.

