Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZCWLtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZCWLtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 07:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZCWLtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 07:49:00 -0400
Received: from bu3sch.de ([62.75.166.246]:33543 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbZCWLs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 07:48:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Date: Mon, 23 Mar 2009 12:47:13 +0100
User-Agent: KMail/1.9.9
Cc: Rui Santos <rsantos@grupopie.com>,
       Michael =?utf-8?q?B=C3=BCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
References: <200903041828.49972.m.bueker@berlin.de> <49BE4EF6.3030406@grupopie.com> <20090322211159.GA23042@electric-eye.fr.zoreil.com>
In-Reply-To: <20090322211159.GA23042@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903231247.13467.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 March 2009 22:12:00 Francois Romieu wrote:
> Can you see if one of the attached patches or a combination of them
> makes a difference for the current (-git) kernel ?

I think I'm forced to run the test on 2.6.28.8, because current linus-git has
major bugs in it that let pppd completely fail, which is required for proper operation
of the machine.

These two patches apply cleanly (with a small offset) to 2.6.28.8, so I guess
there's no problem with trying these on the stable kernel.

-- 
Greetings, Michael.
