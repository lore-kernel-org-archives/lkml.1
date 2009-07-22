Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZGULJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZGULJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbZGULJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:09:33 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36290 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZGULJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=msdA+0vrw49wfyXMxlT552OATxB8B/lcZosY7E3cQkvBGo0BmEFd6fuScIPXAgkFVU
         icnwgDsBmjK+k81RT7PXHSmJBNkpSD8SKsq5gw6L6D4rE7BxIlQc4Nh+4RLNsq7+p4iZ
         JrGlvjQUi2631B3wGy4EFY1G/OY2TVHbIry6s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: checkpatch whitespace
Date: Wed, 22 Jul 2009 13:05:27 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090720-03987-ged696ea; KDE/4.2.4; i686; ; )
Cc: apw@canonical.com, kernel list <linux-kernel@vger.kernel.org>
References: <20090721100113.GC4133@elf.ucw.cz>
In-Reply-To: <20090721100113.GC4133@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221305.28115.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009 12:01:14 Pavel Machek wrote:

> Would it be possible to add autofixing to checkpatch? Fixing
> whitespace issues by hand is useless & boring task...

That's why most people use scripts for it.. ;)

scripts/cleanfile
scripts/cleanpatch

Maybe we should make checkpatch inform people about them
(if any whitespace errors were detected)..
