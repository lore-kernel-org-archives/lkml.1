Return-Path: <linux-kernel-owner+w=401wt.eu-S1764724AbYFZNHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764724AbYFZNHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761361AbYFZMt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:49:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:28651 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758957AbYFZMt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:49:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qFi/BkvJl6VHRPkpLdIeWZEjN64fFo/cI5L3jgV5J+nRbnb5LXVlcm2ep5A4BOLwYK
         X3S6ofwAvVhwY87pguq4RSeV68pn8Vr/EI98Qc+s3W/4FXIXhXG202D1k6y3PdhSTbSB
         WYWCHQ8wDd3snB7AsE1ClqLfw1XXkeF3eNgPk=
Message-ID: <6101e8c40806260549m63ca2899hd1d13de0bd36a6d4@mail.gmail.com>
Date: Thu, 26 Jun 2008 14:49:54 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>,
       "Dave Chinner" <david@fromorbit.com>
Subject: Re: [XFS] kernel panic on halt (2.6.26-rc7)
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       "Eric Sandeen" <sandeen@sandeen.net>, "Matthew Wilcox" <matthew@wil.cx>
In-Reply-To: <6101e8c40806260532j3bed1c7k9a60c41ea297549f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40806260532j3bed1c7k9a60c41ea297549f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(this an other machine, than the earlier)

and same problem[1]

[1] http://archives.free.net.ph/message/20080616.045221.1905ae63.en.html
[2] http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00807.jpg


On 6/26/08, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> Hi Christoph, Dave,
>
> a similar problem came out the with 2.6.26, than the was in post early
> with 2.6.25[1][2]
>
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00807.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00808.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00809.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00810.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00811.jpg
>
> the git head is on 2.6.26-rc7,
> was an any kind of bigger load however here, only desktop usage
>
> the compiler is GCC-4.3.1 gcc (Debian 4.3.1-2) 4.3.1
> pc: i386 (Pentium 4 HT Northwood, with enabled HT )
>
> fs usage: 88%
>
>
> --
> [1] http://archives.free.net.ph/thread/20080616.100122.14303e7a.en.html
> [2] http://students.zipernowsky.hu/~oliverp/upload/xfs_error/
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
