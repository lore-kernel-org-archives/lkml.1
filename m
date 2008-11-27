Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYK0JdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYK0JdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 04:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYK0JdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 04:33:08 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:45770 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYK0JdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 04:33:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=GOmgyrSVc9aEAKV3NYKXCsHJTCHKGnqLe8ZVfEgGuK2P3L6F23zr7tUXcS63RWIlOX
         QshaLkRKjOoW+oAERhCygt0QcmCJQHhnQi6PFvzMAgS8XSSXWU6sMMf7tGxGWQjIAgvz
         Y6TEpQsK2OPF9SDN67a7F7CXkjQJ9eazM3CQk=
Message-ID: <84144f020811270133r179828eat69b24c067c55447@mail.gmail.com>
Date: Thu, 27 Nov 2008 11:33:03 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Markus Rechberger" <mrechberger@gmail.com>
Subject: Re: [PATCH 1/7] Adding empia base driver
Cc: "Aidan Thornton" <makosoft@googlemail.com>, "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <d9def9db0811262025v5d1b0df4h3855cb6023be2cf7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	 <20081022220903.GA15278@kroah.com>
	 <d9def9db0810221524m738b838bs681c0b9159531c64@mail.gmail.com>
	 <c8b4dbe10811261112w6cbbec73mb468870f206d9f97@mail.gmail.com>
	 <d9def9db0811262025v5d1b0df4h3855cb6023be2cf7@mail.gmail.com>
X-Google-Sender-Auth: c01cdbd6e57285c9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 6:25 AM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> I simply don't have the time for those games anymore, and those people here who have personal
> issues with me and/or my work don't pay my monthly bills, neither do they have any clue how that
> driver is used with some systems of certain customers. I constantly deliver full solutions, and not
> driver code only. Neither am I limited to Linux only.

Again, it's not personal, it's the way we do things here. But you
should already know that by now so whatever.

What puzzles me the most here is why isn't Empia simply providing
datasheets to other developers as well. I mean, even the GPU and
wireless vendors know how to play well with the community now, so
what's the problem? Being locked to just one developer who's unwilling
to cooperate doesn't sound like a winning strategy to me.

Greg, is there any reason we don't have Markus' out-of-tree driver
listed here, btw:

  http://www.linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers

Maybe there are people in the "Linux Driver Project" that could be
interested in working on this but simply don't know about it?

                               Pekka
