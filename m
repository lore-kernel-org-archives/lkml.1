Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbYFLSOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbYFLSOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 14:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYFLSOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 14:14:04 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48570 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbYFLSOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 14:14:02 -0400
Date: Thu, 12 Jun 2008 20:14:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: vibi sreenivasan <vibisreenivasan.kernel@gmail.com>
Cc: Abhishek Singh <abhi.iitg@gmail.com>,
       Rakib Mullick <rakib.mullick@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: WARNING : section mismatch while compiling 2.6.25.6
Message-ID: <20080612181443.GC2271@uranus.ravnborg.org>
References: <f1d7325b0806120029y5f5e0bd8i6caa626bf9af59df@mail.gmail.com> <3219c8500806120033q60f02574p682e9331311eb0dd@mail.gmail.com> <f1d7325b0806120707r4212c2e7x6b0f53218bc23bf9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1d7325b0806120707r4212c2e7x6b0f53218bc23bf9@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 02:07:40PM +0000, vibi sreenivasan wrote:
> hi,
> i tried with make defconfig & then make .
> i am getting same error.
This is a warning that should be fixed in latest -rc kernel
by commit: ed49f5d0015927334dcca3607a9bfc1478ff8f55

You can safely ignore the warning.

	Sam
