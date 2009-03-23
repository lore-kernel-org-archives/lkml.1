Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbZCWPMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbZCWPMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbZCWPMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:12:30 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:52167 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbZCWPM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=mqWUqYuld3g0ja5j7KbqNWnPsBfu9AFr5Vharcartu3KqffMO+zdTfNPN0rYe/CObU
         /8EU3lVZOqQ3tPfJjEXxWKT47tzNleYUdHgP60rvyhTvSL2f7U44iHFeYI4rYT4Bip32
         vcJEtyfAJPIxlEajEj0n6mCqRO5kDVjwLZlSI=
MIME-Version: 1.0
In-Reply-To: <20090323150804.GG13368@mit.edu>
References: <20090320030121.1fa8e6d3.akpm@linux-foundation.org>
	 <b2080d80903220626s5fffdbf3i907cb4b215670ce6@mail.gmail.com>
	 <b2080d80903200244u7fbcc150g6724a84c9b3b2054@mail.gmail.com>
	 <20090323020522.GF29466@mit.edu>
	 <b2080d80903230210w60d48530n9b98fdf71cf6fd18@mail.gmail.com>
	 <20090323121709.GD13368@mit.edu>
	 <b2080d80903230720m16af65c4t992b9cc34c44b914@mail.gmail.com>
	 <20090323150804.GG13368@mit.edu>
Date: Mon, 23 Mar 2009 16:12:25 +0100
X-Google-Sender-Auth: 6a7257081d418c2c
Message-ID: <b2080d80903230812s2a33b635vf70f7736133570c7@mail.gmail.com>
Subject: Re: Severe data corruption with ext4
From: =?ISO-8859-1?Q?Richard_H=F6chenberger?= <richard@r-selected.de>
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 16:08, Theodore Tso <tytso@mit.edu> wrote:

> Was this a freshly created ext4 filesystem, or one that was converted
> from ext3?

Freshly created ext4 fs.

    Richard
