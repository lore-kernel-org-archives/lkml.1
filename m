Return-Path: <linux-kernel-owner+w=401wt.eu-S1764892AbXEVOna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764892AbXEVOna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 10:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbXEVOnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 10:43:22 -0400
Received: from khc.piap.pl ([195.187.100.11]:40364 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbXEVOnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 10:43:21 -0400
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
	<alpine.DEB.0.99.0705220950160.3308@sigma.j-a-k-j.com>
	<Pine.LNX.4.64.0705220959310.14408@localhost.localdomain>
	<a781481a0705220709s40b80208h47f1f2f7c00a684d@mail.gmail.com>
	<a781481a0705220716l799ee2efm268deefc40993875@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 22 May 2007 16:43:19 +0200
In-Reply-To: <a781481a0705220716l799ee2efm268deefc40993875@mail.gmail.com> (Satyam Sharma's message of "Tue, 22 May 2007 19:46:42 +0530")
Message-ID: <m3tzu4kjg8.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Satyam Sharma" <satyam.sharma@gmail.com> writes:

> But of course, John is *bang right* that if /**/ makes gcc do (or not do)
> _anything at all_ (be it crying out a warning), then someone surely
> deserves to get his head bashed in ... :-)

I think it's impossible, comments are removed by preprocessor.
-- 
Krzysztof Halasa
