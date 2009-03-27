Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbZC0UDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbZC0UDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbZC0UCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:02:42 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:42117 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbZC0UCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:content-type:content-transfer-encoding;
        b=RXFsBMv3RaKEzxOjhMEuEjxp9tQpooEsxoz31KUvfjqFm+20G9Vy4u3v2zWKRa7Ys0
         sb73gl0/TNp2Uun2T8ypTsjv6hFSUewSaTf3ZU2kqW7XR+SD5N6TorII8YXjMkgzIy7Z
         eLzrs+Vj7iX3UhZxHq/oVNiET+IxUWX4VzqYM=
MIME-Version: 1.0
Reply-To: aaron@assonance.org
In-Reply-To: <20090327194836.GZ6239@mit.edu>
References: <20090327112438.GQ6239@mit.edu>
	 <alpine.LFD.2.00.0903271058060.3994@localhost.localdomain>
	 <20090327190339.GW6239@mit.edu>
	 <200903271519.10921.gene.heskett@verizon.net>
	 <20090327194836.GZ6239@mit.edu>
Date: Fri, 27 Mar 2009 16:02:39 -0400
Message-ID: <727e50150903271302t5ba37a71q28cb3627862675c1@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: Aaron Cohen <remleduff@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Gene Heskett <gene.heskett@verizon.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And of course, if you want *all* of ext4's benefits, including the
> full factor of 6-8 improvement in fsck times, then you will be best
> served by creating a new ext4 filesystem from scratch and doing a
> backup/reformat/restore pass.
>

Does a newly create ext4 partition have all the various goodies
enabled that I'd want, or do I also need to tune2fs some parameters to
get an "optimal" setup?

-- Aaron
