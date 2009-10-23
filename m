Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbZJWOse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbZJWOse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZJWOse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:48:34 -0400
Received: from ozlabs.org ([203.10.76.45]:35896 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbZJWOsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:48:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Takashi Iwai <takashi.iwai@gmail.com>
Subject: Re: Problems with string (charp) module parameters
Date: Sat, 24 Oct 2009 01:18:35 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
References: <s5haazv1sw5.wl%tiwai@suse.de> <6dc076840910211913l1cf12e82tbb9151da78e41422@mail.gmail.com> <200910230050.41790.rusty@rustcorp.com.au>
In-Reply-To: <200910230050.41790.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910240118.36256.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Oct 2009 12:50:41 am Rusty Russell wrote:
> I'll post my current patch series: it needs testing, but I'd appreciate
> your thoughts.

OK, ignore that.  I have two new series.  Tested.

The first is for 2.6.32.  It's simple, and avoids the worst problems.

The real fix is the longer series, for 2.6.33.

Thanks,
Rusty.
