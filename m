Return-Path: <linux-kernel-owner+w=401wt.eu-S1762973AbXF0V34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762973AbXF0V34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 17:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbXF0V3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 17:29:47 -0400
Received: from bay0-omc2-s3.bay0.hotmail.com ([65.54.246.139]:54056 "EHLO
	bay0-omc2-s3.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753806AbXF0V3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 17:29:46 -0400
X-Originating-IP: [65.93.40.159]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Wed, 27 Jun 2007 17:29:40 -0400
From: Sean <seanlkml@sympatico.ca>
To: Crispin Cowan <crispin@novell.com>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
Message-Id: <20070627172940.1cabd5c4.seanlkml@sympatico.ca>
In-Reply-To: <4682D13C.6060107@novell.com>
References: <20070626230756.519733902@suse.de>
	<20070626165202.bfe8e6df.akpm@linux-foundation.org>
	<20070627022403.GB14656@suse.de>
	<20070626194700.5b0ff477.akpm@linux-foundation.org>
	<20070627151114.GM1094@stusta.de>
	<4682D13C.6060107@novell.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2007 21:30:08.0406 (UTC) FILETIME=[55CF2360:01C7B902]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 14:06:04 -0700
Crispin Cowan <crispin@novell.com> wrote:

> I am hoping for a reconciliation where the people who don't like
> AppArmor live with it by not using it. AppArmor is not intended to
> replace SELinux, it is intended to address a different set of goals.

You keep saying that.   But for that to be true you'd have to believe
_everyone_ using Novell distributions has needs that align exactly
with AppArmor.  Otherwise, how to explain that you don't offer and
support both SELinux and AppArmor to your users?

It seems as far as Novell is concerned, AppArmor _is_ meant to replace
SELinux.  Not that there is really anything wrong with that, but it's
a little disingenuous to then argue that they're meant to coexist.

Sean
