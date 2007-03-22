Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbXCVWB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbXCVWB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbXCVWB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:01:29 -0400
Received: from gw.goop.org ([64.81.55.164]:43321 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbXCVWB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:01:28 -0400
Message-ID: <4602FCBA.20005@goop.org>
Date: Thu, 22 Mar 2007 15:01:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@qumranet.com>,
       Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH] make KVM conform to sucky rdmsr interface
References: <1174531917.2713.91.camel@localhost.localdomain>	<46022E40.8080300@qumranet.com>	<1174549770.2713.121.camel@localhost.localdomain> <20070322143011.0cf83370.akpm@linux-foundation.org>
In-Reply-To: <20070322143011.0cf83370.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Which tree are you patching??
> -

It looks like its against the previously posted "Cleanup: rationalize
paravirt wrappers" patch.

    J
