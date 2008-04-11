Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbYDKVqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbYDKVqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbYDKVqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:46:12 -0400
Received: from khc.piap.pl ([195.187.100.11]:40270 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbYDKVqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:46:11 -0400
To: Marc Perkel <mperkel@yahoo.com>
Cc: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: AMD Quad Core clock problem?
References: <821384.64293.qm@web52504.mail.re2.yahoo.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 11 Apr 2008 23:46:09 +0200
In-Reply-To: <821384.64293.qm@web52504.mail.re2.yahoo.com> (Marc Perkel's message of "Fri\, 11 Apr 2008 14\:36\:31 -0700 \(PDT\)")
Message-ID: <m3y77knjz2.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel <mperkel@yahoo.com> writes:

> No - it's not wild like it was back in the early X2
> days and I think you're right about the drift being
> normal.

Few seconds an hour is hardly normal, thats 0.1%. The prime suspect
is probably the motherboard and it's faulty clock generator (one of
- HPET's?).

What motherboard is it?
-- 
Krzysztof Halasa
