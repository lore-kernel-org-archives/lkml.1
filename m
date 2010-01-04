Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318Ab0ADJgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0ADJgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 04:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439Ab0ADJge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 04:36:34 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49715 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0ADJgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 04:36:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EDGVWGVpoHdXdJdlcaubI/xVHWQ/U22A+mE5kkW62HR9oX6p3Li/Oq2y8SDDpwnPIs
         NsLb0IQyi1yueUVD0RRBlpbTsa38eLb136Q6grXIhuTsLr6XwblQi7cYWel/qE5P8KBl
         1yMwp7VEGBJtk9ldLjvr0OftSV0sK9LJYb7Co=
Date: Mon, 4 Jan 2010 10:35:46 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Yan, Zheng " <yanzheng@21cn.com>
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: 2.6.33-rc2+ bug in fs/btrfs/ordered-data.c:672
Message-ID: <20100104093546.GA5699@Pilar.aei.mpg.de>
References: <20100102103227.GA3678@Pilar.aei.mpg.de>
 <20100102223416.GA6090@Pilar>
 <201001040122.36431.johannes.hirte@fem.tu-ilmenau.de>
 <3d0408631001032020n10d82ea4x1ecde375bd46060a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d0408631001032020n10d82ea4x1ecde375bd46060a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo  4.Jan'10 at 12:20:18 +0800, Yan, Zheng  wrote:

> > Sounds like the bug reported here: http://article.gmane.org/gmane.comp.file-
> > systems.btrfs/4332/match=btrfs+fails+randomly. Can you try the patch provided
> > in that thread?
> >
> I have sent a patch for this.
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03686.html

Thanks for pointing it out, my google search missed that report.

I am already testing that patch, and if you don't hear back from
me than all is fine.

Thanks again.
