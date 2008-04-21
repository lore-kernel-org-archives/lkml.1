Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYDUU3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYDUU3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYDUU3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:29:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:59115 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbYDUU3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gKe4JDOXDbhV3UKTRgbU5GEAyE4TUBt/pYx46e5Kyas0G/IoYL4s5nYU6US7qLXJzXLFB7W94a1J55mTr5T2w7bE1kZZKmGnW4uxkFAfRgYRBZKSgq4k5rn4Hr3WUjhyd+tbS066syfrjE02qR0ZIeIO0xniaUf4euivsPYdyh8=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: x86: 4kstacks default
Date: Mon, 21 Apr 2008 22:28:25 +0200
User-Agent: KMail/1.8.2
Cc: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <480C96BC.4020400@sandeen.net> <200804212151.02241.vda.linux@googlemail.com>
In-Reply-To: <200804212151.02241.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804212228.25978.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2008 21:51, Denys Vlasenko wrote:
> Why xfs code is said to be 5 timed bigged than e.g. reiserfs?

s/timed bigged/times bigger/
