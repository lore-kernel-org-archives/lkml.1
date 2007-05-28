Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbXE1Nry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbXE1Nry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXE1Nrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:47:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:14273 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbXE1Nrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mREFy6MuZpD+KYcx8D9WeUp4Y7eRkhtMWjO5VgfY5QsD6ZQ42F0etvtGJFh0HobURwwL3OQyfUTaID7mqIK/one91F4WfnmiqqKrLOA7B8oCH7rVWp6NzPDQfdvB00SMDh0Wspxj7A3YYP9FifrKJSyTAqDiXpqAroBCFt5n6w8=
Message-ID: <84144f020705280647h79e429c0l96e15388c8beaf00@mail.gmail.com>
Date: Mon, 28 May 2007 16:47:43 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Michael-Luke Jones" <mlj28@cam.ac.uk>
Subject: Re: [RFC] LZO de/compression support - take 5
Cc: "Nitin Gupta" <nitingupta910@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm-cc@laptop.org,
       linuxcompressed-devel@lists.sourceforge.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Richard Purdie" <richard@openedhand.com>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Bret Towe" <magnade@gmail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <E3A63767-F44E-404B-BA43-8DEB223CCAC7@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705272359o16725994k7f3c01b99c5691cd@mail.gmail.com>
	 <871A3BF3-A0EA-40E4-AB5F-FF6DDCE12DC7@cam.ac.uk>
	 <4cefeab80705280509x73c8a1c9m9e8ba58d235a3666@mail.gmail.com>
	 <E3A63767-F44E-404B-BA43-8DEB223CCAC7@cam.ac.uk>
X-Google-Sender-Auth: 54889ae869fb4360
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Michael-Luke Jones <mlj28@cam.ac.uk> wrote:
> No, LZO as a visible option makes no practical sense. Why would
> anyone want to build LZO into a kernel when there are no in-kernel
> users of the code?

Agreed. It should be a auto-selected hidden config option.
