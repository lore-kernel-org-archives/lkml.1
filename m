Return-Path: <linux-kernel-owner+w=401wt.eu-S932902AbZKDVom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbZKDVom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932744AbZKDVoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:44:39 -0500
Received: from mail.crca.org.au ([67.207.131.56]:44798 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873AbZKDVoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:44:37 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4AF1F611.6050206@crca.org.au>
Date: Thu, 05 Nov 2009 08:45:53 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "TuxOnIce users' list" <tuxonice-users@lists.tuxonice.net>
CC: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [TuxOnIce-users] An assortment of TuxOnIce resume panics on a
 Radeon KMS-running system in 2.6.31.5, lzo-related?
References: <87ocnim1bj.fsf@spindle.srvr.nix>
In-Reply-To: <87ocnim1bj.fsf@spindle.srvr.nix>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Thanks for your bug report.

I'd say it's a bug in the TuxOnIce code. How recent a version are you
running? (It's been a while since I bumped the version number, so saying
3.0.1 doesn't mean much any more). Is it recent git?

Would you also let me know how your storage is configured - file
allocator? swap allocator? More than one swap device? priorities? (I've
been doing work in this area recently, and so suspect that it might be
the cause).

Regards,

Nigel
