Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbZGKLGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbZGKLGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZGKLGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:06:32 -0400
Received: from ozlabs.org ([203.10.76.45]:44155 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbZGKLGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:06:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [FIX REQUEST] x86: smp.h is totally confused about processor ID
Date: Sat, 11 Jul 2009 20:36:22 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <1247299234.2678.10.camel@ht.satnam>
In-Reply-To: <1247299234.2678.10.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907112036.23176.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009 05:30:34 pm Jaswinder Singh Rajput wrote:
> In same structure it using int, unsigned and unsigned int cpu

I prefer unsigned int, but historically it's been very loose.  FWIW, I have no 
problems with a cleanup either way.

Thanks,
Rusty.
