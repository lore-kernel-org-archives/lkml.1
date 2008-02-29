Return-Path: <linux-kernel-owner+w=401wt.eu-S933335AbYB2XRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335AbYB2XRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 18:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYB2XRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 18:17:12 -0500
Received: from khc.piap.pl ([195.187.100.11]:42839 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYB2XRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 18:17:12 -0500
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Few ideas...
References: <m3od9z9y6t.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0803010004350.24056@fbirervta.pbzchgretzou.qr>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 01 Mar 2008 00:17:10 +0100
In-Reply-To: <Pine.LNX.4.64.0803010004350.24056@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Sat\, 1 Mar 2008 00\:11\:28 +0100 \(CET\)")
Message-ID: <m3fxvb9wuh.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> d: I think it would not bad if it were included in the resulting
> object file like MODULE_AUTHOR is.

I specifically don't want it in the binary - maintainers change, it's
not a point of contact for end users. It would be for source code ops
only.

> If anything, MODULE_AUTHOR could be removed, because the original
> author(s) are usually listed at the top of the .c file and not
> always the ones to talk to when there is a bug (=> the maintainer
> is).

Perhaps it's there because of copyright.
-- 
Krzysztof Halasa
