Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbZAOJBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbZAOJBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZAOJB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:01:29 -0500
Received: from hosting.visp.net.lb ([194.146.153.11]:58910 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZAOJB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:01:28 -0500
From: Denys Fedoryschenko <denys@visp.net.lb>
Organization: VISP
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: deadlocks if use htb
Date: Thu, 15 Jan 2009 11:01:14 +0200
User-Agent: KMail/1.9.9
Cc: Badalian Vyacheslav <slavon@bigtelecom.ru>, Chris Caputo <ccaputo@alt.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20081010090426.GA6054@ff.dom.local> <496EE1D4.6010709@bigtelecom.ru> <20090115080921.GC4190@ff.dom.local>
In-Reply-To: <20090115080921.GC4190@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151101.15397.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009 10:09:21 Jarek Poplawski wrote:
> Slavon, I'm very glad of your testing and reporting, and I never
> expected you test anything on production, when something else works
> for you. On the other hand, what works for you could be unacceptable
> for other users, who don't have such crashes, and prefer better
> exactness. So it's hard to recommend such patches if there is not
> enough people interested in them.
>
> Best regards,
> Jarek P.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Jarek, can you give me exact name of patch or link to it?
I will test it on production.
And i am interested in searching, what is a problem.
