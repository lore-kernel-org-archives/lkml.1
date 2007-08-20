Return-Path: <linux-kernel-owner+w=401wt.eu-S1762136AbXHTVaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762136AbXHTVaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbXHTV3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:29:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:41786 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbXHTV3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:29:52 -0400
In-Reply-To: <20070820202356.GA31712@redhat.com>
References: <20070820200856.GA4194@redhat.com> <20070820201818.A68C54D05F2@magilla.localdomain> <20070820202356.GA31712@redhat.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <4470f8769f958e0b46eea116ae0e1105@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>, Roland McGrath <roland@redhat.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [POWERPC] Fix for assembler -g
Date: Mon, 20 Aug 2007 23:29:46 +0200
To: Dave Jones <davej@redhat.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In a way though, good thing, or mainline would have continued to be
> broken :)

What do I need to do to see this bug, btw?  A special config
symbol perhaps?


Segher

