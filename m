Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYABVws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYABVws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYABVwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:52:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54558 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbYABVwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:52:38 -0500
Date: Wed, 2 Jan 2008 22:54:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Russell Leidich <rml@google.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       valdis.kletnieks@vt.edu
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Message-ID: <20080102215433.GB13784@one.firstfloor.org>
References: <20071225140413.e8b4f2cd.akpm@linux-foundation.org> <3f1a065b0712271057s150b62f8nb11ebc28dc55f811@mail.gmail.com> <20071227233419.d1adf3f3.akpm@linux-foundation.org> <3f1a065b0712281240p14c8223agfe83db0ac26aca4c@mail.gmail.com> <p731w9410yc.fsf@bingen.suse.de> <3f1a065b0801021143y5fc15e29r4201ac19bc7c1daa@mail.gmail.com> <20080102200039.GA13784@one.firstfloor.org> <3f1a065b0801021312w6f823cbeh9ea6b73d2b0c46c8@mail.gmail.com> <64bb37e0801021333g3cccff81k68df75463e4a21d0@mail.gmail.com> <3f1a065b0801021350x7fd065fbj9680ce1a4f3c6538@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f1a065b0801021350x7fd065fbj9680ce1a4f3c6538@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks.  My code doesn't support these CPUs because their northbridge
> IDs are not 0x1203.

Sure, but do they have the crippling erratum too?

-Andi
