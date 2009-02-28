Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZB1Tc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZB1Tc2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 14:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZB1TcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 14:32:19 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:62411 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbZB1TcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 14:32:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sEiYL8s9T4iR5UGRV8EhxRoYT+F49f5CtECD0A+VLOjtV7x63Ii+hZZkyYAF+UI0W8
         mruGi9muUVKHipR38h8gKkUFfOI0I9X7HZJuOjd3mAd4gsqZj6ciiU+wXoCzxxxdrmKM
         2JWAhVPlU5NH+qbnIFL1audaxySaBTnWw88Y4=
MIME-Version: 1.0
In-Reply-To: <2c0942db0902140940v4b16c517mcbcd4874466e5158@mail.gmail.com>
References: <6bd94bae0902130829r15e6eacag25220487457027ad@mail.gmail.com>
	 <2c0942db0902140940v4b16c517mcbcd4874466e5158@mail.gmail.com>
Date: Sat, 28 Feb 2009 20:32:15 +0100
Message-ID: <6bd94bae0902281132u4a54fe55r2d604e0558051c66@mail.gmail.com>
Subject: Re: contact problem? (was Re: Spurious Filesystem corruption with 
	ext3 + large (<400GB) hw RAID ...)
From: Manfred Wassmann <tux.wassmann@googlemail.com>
To: Ray Lee <madrabbit@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 18:40, Ray Lee <madrabbit@gmail.com> wrote:
[...]
> (Ah, I missed this message first time around. Please always do a
> reply-to-all for lkml.)

Thanks, that's always a problem with mailing lists, you never know,
some people want CCs and some -- like me -- don't ;-)

> Bad contacts, sure, or (more likely) a marginal power supply? Can you
> try a different enclosure, or a different power supply for the
> enclosure?

Now it looks like the disk is the problem, this week the array again
reported degrades state with the same disk as before being flagged as
defective but some time later everything was OK. The disk now has been
replaced.
Live was easier when disks were either good or bad ;-)
