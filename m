Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYCYOai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYCYOai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 10:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYCYOac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 10:30:32 -0400
Received: from khc.piap.pl ([195.187.100.11]:53594 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbYCYOab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:30:31 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       ebiederm@xmission.com, xemul@openvz.org, pavel@ucw.cz,
       sds@tycho.nsa.gov, roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
References: <20080323135110.GA294@tv-sign.ru>
	<20080324152906.dee7b272.akpm@linux-foundation.org>
	<20080324225611.GA157@tv-sign.ru>
	<20080324160819.cea2d921.akpm@linux-foundation.org>
	<87r6dzi0mw.fsf@basil.nowhere.org>
	<m3fxuedh3m.fsf@maximus.localdomain>
	<20080325142259.GO2170@one.firstfloor.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 25 Mar 2008 15:30:29 +0100
In-Reply-To: <20080325142259.GO2170@one.firstfloor.org> (Andi Kleen's message of "Tue\, 25 Mar 2008 15\:22\:59 +0100")
Message-ID: <m37ifqdgfu.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> The problem is that you can deadlock if you are not very careful.

I can damage the system in trillion ways, one more is not a problem
:-)

Hopefully someone will write the details down to enable root to be
very careful.
-- 
Krzysztof Halasa
