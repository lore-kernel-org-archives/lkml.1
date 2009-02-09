Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbZBIJyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbZBIJyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZBIJxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:53:34 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:45923 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbZBIJxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:53:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hoZaJC81LxLfpCu4tQjyO0fd3cjdYowk+dyVjpy/N+izeheVyKLIWzXBq5N0C23NZD
         W8sRh8MFsD6gvgchDBbgq4aiyLe6G8p/XMVUrpKcZWLUZOImp6ByjZX0saIOrj+9jrps
         ohhYCoTOuLlfM8qUfTE3cYmFTIMRleKI4mmVk=
MIME-Version: 1.0
In-Reply-To: <20090209094748.GC4358@atrey.karlin.mff.cuni.cz>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <498D9F02.9000107@tremplin-utc.net>
	 <cb7bb73a0902071559w70b3367el9471db894872257f@mail.gmail.com>
	 <20090209094748.GC4358@atrey.karlin.mff.cuni.cz>
Date: Mon, 9 Feb 2009 10:53:30 +0100
Message-ID: <cb7bb73a0902090153q30a5337bj45d41a3e3919e189@mail.gmail.com>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "?ric Piel" <eric.piel@tremplin-utc.net>, linux-kernel@vger.kernel.org,
       Palatis Tseng <palatis@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/9 Pavel Machek <pavel@suse.cz>:
> Ok, at my machine it fluctuates around 1K when sitting on the desk,
> and maximum range is about 13-15K. So your values seem little too noisy.

I suspected as much. Do you think this is a hardware problem, or
something that can be worked around in software? Or maybe I just leave
in a very shaky neighborohood (although there's little or no car
traffic around here) ...

-- 
Giuseppe "Oblomov" Bilotta
