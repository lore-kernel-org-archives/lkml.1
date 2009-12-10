Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbZLJPQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbZLJPQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 10:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760885AbZLJPQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 10:16:47 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:13751 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760870AbZLJPQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 10:16:46 -0500
Message-ID: <4B2110E3.8010508@hp.com>
Date: Thu, 10 Dec 2009 10:16:51 -0500
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dan Carpenter <error27@gmail.com>,
       Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Documentation/email-clients.txt: clarify Thunderbird
 section
References: <4B210C6C.3060103@tuffmail.co.uk>
In-Reply-To: <4B210C6C.3060103@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have a problem with your patch, but it is not true
that you need to edit the prefs.js to disable line wrap.

I did this in the gui to fix my own patch sending,
under "Composition" you can set the wrap = 0.

While changing format=flowed does require editing the file,
on my version of Thunderbird, 2.0.0.23, it isn't clear how
it breaks the patch to leave it flowed.

And I have never used HTML, Preformat.

jim

Though now that I have said that, Andrew will probably
tell me the patch I sent is broken ;)
