Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbZCXJpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbZCXJpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757901AbZCXJov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:44:51 -0400
Received: from bu3sch.de ([62.75.166.246]:48940 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757645AbZCXJou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:44:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Date: Tue, 24 Mar 2009 10:43:30 +0100
User-Agent: KMail/1.9.9
Cc: Rui Santos <rsantos@grupopie.com>,
       Michael =?iso-8859-1?q?B=C3=BCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
References: <200903041828.49972.m.bueker@berlin.de> <200903231347.01707.mb@bu3sch.de> <20090323234730.GA19854@electric-eye.fr.zoreil.com>
In-Reply-To: <20090323234730.GA19854@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903241043.31119.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 March 2009 00:47:30 Francois Romieu wrote:
> Michael Buesch <mb@bu3sch.de> :
> [...]
> > Ok, it still happens with both patches applied to 2.6.28.8
> 
> So no change of behavior for you : kernel warning _and_ unreliable
> network connectivity ?

Well, the connectivity never was "unreliable", but due to the frequent watchdog
reset there were connectivity stalls of 5 seconds or so when it happens.

-- 
Greetings, Michael.
