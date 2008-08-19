Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbYHSKbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbYHSKbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbYHSKbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:31:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48246 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYHSKbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:31:42 -0400
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Karsten Keil <kkeil@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ISDN fixes
From: Andi Kleen <andi@firstfloor.org>
References: <20080819101225.GA17310@pingi.kke.suse.de>
	<1219141608.7591.118.camel@violet.holtmann.net>
Date: Tue, 19 Aug 2008 12:31:40 +0200
In-Reply-To: <1219141608.7591.118.camel@violet.holtmann.net> (Marcel Holtmann's message of "Tue, 19 Aug 2008 12:26:48 +0200")
Message-ID: <87tzdhz46r.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann <marcel@holtmann.org> writes:

> Hi Karten,
>
>> please pull the ISDN fixes from
>> git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master
>
> can you include "git-diff -M --stat --summary" and "git-shortlog" in the
> pull requests so others know what changes are in your tree.

The easiest way to do that is git request-pull (just to save you
some manpage reading, Karsten) 

-Andi
