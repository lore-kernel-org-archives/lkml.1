Return-Path: <linux-kernel-owner+w=401wt.eu-S939898AbXGSQZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939898AbXGSQZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936187AbXGSQYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:24:37 -0400
Received: from gw.goop.org ([64.81.55.164]:51162 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937186AbXGSQYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:24:35 -0400
Message-ID: <469F900C.5060709@goop.org>
Date: Thu, 19 Jul 2007 09:23:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: chrisw@sous-sol.org
CC: Andi Kleen <ak@suse.de>, mingo@elte.hu, johnstul@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for review] [26/48] i386: hpet assumes boot cpu is 0
References: <20070719348.540885000@suse.de> <20070719134856.3813D14E6E@wotan.suse.de>
In-Reply-To: <20070719134856.3813D14E6E@wotan.suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: Chris Wright <chrisw@sous-sol.org>
>
> I fixed this in x86_64.  Looks like the kind of thing that will break voyager
> on i386.
>   

All those Voyagers with hpet?

    J
