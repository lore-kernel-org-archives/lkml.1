Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZCLLlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZCLLlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZCLLk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:40:56 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:51771 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbZCLLkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uGwoOY/Pv+TCtc1UCEIa0bFX0wr3WbpkK4iXojTSYSkrL14slrCSY82wvcRId2I66e
         jeweH7Ga4P+OhrMJzaScZsmyXp8VVU6tTLdIQNVNytXfCoU1+X42hEOJyZlH0QBLY/Dr
         tikWzEBZfIzRpHstHB1XjUHzyA59u3qFgsE4Y=
MIME-Version: 1.0
In-Reply-To: <20090312092114.GC6949@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz>
Date: Thu, 12 Mar 2009 11:40:52 +0000
Message-ID: <ef1cd66f0903120440q6e49b90dye92abfaa455055b0@mail.gmail.com>
Subject: Re: ext2/3: document conditions when reliable operation is possible
From: =?ISO-8859-1?Q?Jochen_Vo=DF?= <jochen.voss@googlemail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       mtk.manpages@gmail.com, tytso@mit.edu, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2009/3/12 Pavel Machek <pavel@ucw.cz>:
> diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
> index 4333e83..b09aa4c 100644
> --- a/Documentation/filesystems/ext2.txt
> +++ b/Documentation/filesystems/ext2.txt
> @@ -338,27 +339,25 @@ enough 4-character names to make up unique directory entries, so they
>  have to be 8 character filenames, even then we are fairly close to
>  running out of unique filenames.
>
> +Requirements
> +============
> +
> +Ext3 expects disk/storage subsystem to behave sanely. On sanely
   ^^^^
Shouldn't this be "Ext2"?

All the best,
Jochen
-- 
http://seehuhn.de/
