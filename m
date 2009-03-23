Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbZCWO3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbZCWO3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 10:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbZCWO32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 10:29:28 -0400
Received: from michelle.daybyday.de ([85.183.245.167]:38356 "EHLO
	michelle.daybyday.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbZCWO31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 10:29:27 -0400
From: Michael =?iso-8859-1?q?B=FCker?= <m.bueker@berlin.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Date: Mon, 23 Mar 2009 15:29:17 +0100
User-Agent: KMail/1.9.7
Cc: Rui Santos <rsantos@grupopie.com>, linux-kernel@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>
References: <200903041828.49972.m.bueker@berlin.de> <49BE4EF6.3030406@grupopie.com> <20090322211159.GA23042@electric-eye.fr.zoreil.com>
In-Reply-To: <20090322211159.GA23042@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903231529.18064.m.bueker@berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 March 2009, Francois Romieu wrote:
> Can you see if one of the attached patches or a combination of them
> makes a difference for the current (-git) kernel ?

I have not tried your patches, but I'd like to point out that I can also 
reproduce this error with a card that uses the 8139too driver, so it seems 
unlikely to me that the root of it all lies in the r8169 code.

Please don't be annoyed if this comment is utterly unqualified, it just seems 
like a point that should be made :)

Michael

-- 
Installing Windows XP on a Macintosh is like giving a dolphin AIDS.
