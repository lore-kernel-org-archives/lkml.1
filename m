Return-Path: <linux-kernel-owner+w=401wt.eu-S1760340AbYG1R0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbYG1R0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYG1R0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:26:02 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:38490 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYG1R0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HgRe1Jb3TG2/WdCf5P3oVthQjYydAjOXSpq9knnZGoP720El9h72fFITK2lY7vj00p
         JOhnPZPBc+u4OzNZFquJ2kosmuv08d1vniiMtG9uT5P/Xb0TcAuN2jH+EojauEaG1A1h
         WRgx0kllTqs/VXBL6h7O6RdOyZcMKwY1pLrOo=
Message-ID: <9e4733910807281025h7d5a066bwa4be7a99272bc228@mail.gmail.com>
Date: Mon, 28 Jul 2008 13:25:59 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Christian Borntraeger" <borntraeger@de.ibm.com>
Subject: Re: 463 kernel developers missing!
Cc: "Adrian Bunk" <bunk@kernel.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200807281915.32857.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
	 <20080728153546.GD30612@cs181140183.pp.htv.fi>
	 <9e4733910807280845y7e07486n84794a6e74cb59c2@mail.gmail.com>
	 <200807281915.32857.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/08, Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> Am Montag, 28. Juli 2008 schrieb Jon Smirl:
>
> > > You count merges as patches.
>  >
>  > I just used the output from git shortlog, is there a better way?
>
>
> git-shortlog --no-merges
>
>  You can also avoid the grepping:
>
>  git-shortlog -n -s --no-merges
>

Top 20 without the merges.
Apparently Linus really doesn't write code.

  1770	Adrian Bunk
  1735	Al Viro
  1716	David S. Miller
  1367	Ralf Baechle
  1280	Andrew Morton
  1277	Ingo Molnar
  1196	Takashi Iwai
  1091	Tejun Heo
  1071	Bartlomiej Zolnierkiewicz
  1031	Patrick McHardy
  1016	Stephen Hemminger
   969	Andi Kleen
   945	Thomas Gleixner
   904	Russell King
   822	Alan Cox
   809	Paul Mundt
   771	Jean Delvare
   727	Trond Myklebust
   721	Michael Krufky



-- 
Jon Smirl
jonsmirl@gmail.com
