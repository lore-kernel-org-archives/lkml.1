Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbYF3KLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbYF3KLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbYF3KLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:11:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:40357 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbYF3KLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ESf26pqWNkPoRvAiv01mgopRQ5YkDufV805D6u5AgUF32z6ogzu7m9rlu8YJgnkoFB
         8sT299ViQH5oeHwR8tobdBLjvHzAW0daUqvvNxQw/52z/EJLfTyWxeYpDKIoPiXxY9/M
         u6ZrKOOnra1jKw1i2UhBUJnVoz3uL6URuUpeA=
Message-ID: <6101e8c40806300311n6798890fk14641e65d202d443@mail.gmail.com>
Date: Mon, 30 Jun 2008 12:11:38 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: david@fromorbit.com
Subject: Re: [XFS] kernel panic on halt (2.6.26-rc7)
Cc: "Al Viro" <viro@zeniv.linux.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, "Eric Sandeen" <sandeen@sandeen.net>,
       "Matthew Wilcox" <matthew@wil.cx>
In-Reply-To: <20080627043113.GZ29319@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40806260532j3bed1c7k9a60c41ea297549f@mail.gmail.com>
	 <20080627043113.GZ29319@disturbed>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/08, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jun 26, 2008 at 02:32:19PM +0200, Oliver Pinter wrote:
>> Hi Christoph, Dave,
>>
>> a similar problem came out the with 2.6.26, than the was in post early
>> with 2.6.25[1][2]
>>
>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00807.jpg
>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00808.jpg
>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00809.jpg
>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00810.jpg
>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00811.jpg
>
> http://lkml.org/lkml/2008/3/7/356

thanks

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>


-- 
Thanks,
Oliver
