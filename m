Return-Path: <linux-kernel-owner+w=401wt.eu-S936874AbZLHXLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936874AbZLHXLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936980AbZLHXLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:11:32 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42666 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936970AbZLHXL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:11:28 -0500
MIME-Version: 1.0
In-Reply-To: <37219a840912081502v3fdf1879xdb28e867eb82884c@mail.gmail.com>
References: <20091208214246.GA21857@kroah.com>
	 <829197380912081349q32b554acob7055431d65fc26f@mail.gmail.com>
	 <37219a840912081502v3fdf1879xdb28e867eb82884c@mail.gmail.com>
Date: Tue, 8 Dec 2009 18:11:33 -0500
Message-ID: <829197380912081511k2ad53053t1a1f73b6e8571f75@mail.gmail.com>
Subject: Re: 2.6.27.40 build error
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 6:02 PM, Michael Krufky <mkrufky@kernellabs.com> wrote:
> Yes -- please drop it for now.  I didn't actually send this for
> 2.6.27.y anyway -- it must have gotten to you some other way.
>
> Devin, if 2.6.27.y needs this fix, can you please generate the
> appropriate backport and test it before we resubmit?

We would have to decide whether it's worth the effort to get a 2.6.27
environment setup to do the necessary regression testing.  At this
point, I would argue that driver was screwed up enough in 2.6.27 that
I wouldn't be inclined to tell users it worked even with this one fix.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
