Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbZBJVjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbZBJVjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZBJVjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:39:15 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:46580 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbZBJVjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:39:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VHEalXRz5UID3SoGgTLnsWbWLluGTlXSFbXuC7ya74yBUP+2HiEL1Hq+SAb/woRa8t
         QFe0b4FaoXdPdcJ7VfsEBIN6zVjYRCTTj+PBcjSkmV1qR77lZiMdvaAxJ6PfXzytL8WC
         /ZZQJIq2aX5G/tbkdkUH79CfsMWGHuddx5ndk=
MIME-Version: 1.0
In-Reply-To: <20090210101019.GB27018@atrey.karlin.mff.cuni.cz>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <498D9F02.9000107@tremplin-utc.net>
	 <cb7bb73a0902071559w70b3367el9471db894872257f@mail.gmail.com>
	 <20090209094748.GC4358@atrey.karlin.mff.cuni.cz>
	 <cb7bb73a0902090153q30a5337bj45d41a3e3919e189@mail.gmail.com>
	 <20090209095803.GD4358@atrey.karlin.mff.cuni.cz>
	 <cb7bb73a0902090345y4ef5d544ta374ee96791a80df@mail.gmail.com>
	 <cb7bb73a0902090533q3acc45b2r7d00b44aa0bdfc90@mail.gmail.com>
	 <20090210101019.GB27018@atrey.karlin.mff.cuni.cz>
Date: Tue, 10 Feb 2009 22:39:13 +0100
Message-ID: <cb7bb73a0902101339g351bdd8cq442bafbeb7985a00@mail.gmail.com>
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

On Tue, Feb 10, 2009 at 11:10 AM, Pavel Machek <pavel@suse.cz> wrote:
>
> Yeah, that patch. Not sure what to do next... you could grab lis3
> manual and see if you can setup chip by hand to get better results...

As Eric pointed out, it looks definitely like an endianness problem,
although there are a few strange things which are happening at the
same time. Is the lis3 manual available online somewhere, or can I
request it to the mfgr?

-- 
Giuseppe "Oblomov" Bilotta
