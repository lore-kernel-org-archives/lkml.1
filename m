Return-Path: <linux-kernel-owner+w=401wt.eu-S1767281AbXDEUMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767281AbXDEUMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767282AbXDEUMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:12:06 -0400
Received: from khc.piap.pl ([195.187.100.11]:47083 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767277AbXDEUMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:12:01 -0400
To: <linux-kernel@vger.kernel.org>
Subject: Re: [TRIVIAL PATCH] remove duplicate prototypes for gunzip() etc.
References: <m3vegadexp.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 05 Apr 2007 22:11:59 +0200
In-Reply-To: <m3vegadexp.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Thu, 05 Apr 2007 17:22:10 +0200")
Message-ID: <m3ircad1io.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:

> Remove duplicate prototypes for error(), gzip_mark() and gzip_release()
> - they are first declared few lines earlier in all these files.

That's obviously
Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
-- 
Krzysztof Halasa
