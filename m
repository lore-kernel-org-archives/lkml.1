Return-Path: <linux-kernel-owner+w=401wt.eu-S1764411AbXEZV4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764411AbXEZV4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 17:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbXEZV4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 17:56:10 -0400
Received: from khc.piap.pl ([195.187.100.11]:37829 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203AbXEZV4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 17:56:09 -0400
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
	<20070522135927.GA2098@stusta.de>
	<Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
	<20070522161951.GC2098@stusta.de> <m3ejl8k6e3.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0705221616270.18792@localhost.localdomain>
	<m37ir0iodl.fsf@maximus.localdomain>
	<a781481a0705230137v4c8ba82fx263212a2958b55b9@mail.gmail.com>
	<Pine.LNX.4.64.0705230908180.4309@localhost.localdomain>
	<a781481a0705230646x9a0255ak4254d05ba5442cad@mail.gmail.com>
	<Pine.LNX.4.64.0705241239560.10926@localhost.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 26 May 2007 23:56:07 +0200
In-Reply-To: <Pine.LNX.4.64.0705241239560.10926@localhost.localdomain> (Robert P. J. Day's message of "Thu, 24 May 2007 12:43:07 -0400 (EDT)")
Message-ID: <m3sl9juu4o.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert P. J. Day" <rpjday@mindspring.com> writes:

> that's not true, AFAICT.  the pattern seems to be that, in the case of
> declarations, attributes go at the end, as in:

Anyway, that attribute has to be in the declarations as without it
there the compiler can't optimize the callers.
-- 
Krzysztof Halasa
