Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbYCAOOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbYCAOOB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 09:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbYCAONv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 09:13:51 -0500
Received: from khc.piap.pl ([195.187.100.11]:37181 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658AbYCAONv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 09:13:51 -0500
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Few ideas...
References: <m3od9z9y6t.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0803010004350.24056@fbirervta.pbzchgretzou.qr>
	<m3fxvb9wuh.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0803010018050.24056@fbirervta.pbzchgretzou.qr>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 01 Mar 2008 15:13:49 +0100
In-Reply-To: <Pine.LNX.4.64.0803010018050.24056@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Sat\, 1 Mar 2008 00\:27\:22 +0100 \(CET\)")
Message-ID: <m3ejaucz1e.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> So what apart from the parsability of a MODULE_MAINTAINER() tag,
> what is different from authors engraving their name into a
> comment at the start of the .c file?

Authors != maintainers.

A script could parse the tags and fill Cc: appropriately.

> A number of .c files (even those that are not just built-in, but can
> also be built as =m) do not have a MODULE_AUTHOR(); and copyright is
> even valid when there is no apparent author name.

Sure, though it's a bit harder to find who is it exactly.
-- 
Krzysztof Halasa
