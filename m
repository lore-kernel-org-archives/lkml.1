Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbZFDQPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbZFDQPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 12:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZFDQPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 12:15:43 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:57120 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbZFDQPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L1UfciKdfDbNxsHGDs0GMc+CrR05ZyPhecFGpUYd2zWISMZ2ygeZlsyDdko293VwAA
         Ig1g2hax4E2LUblzN1qT2Ppc94mLWfmIwWxAiCuFanokitb2X0UdSnxvTeg1Y6DUYmkH
         LCYJs/L2vqMn6+PDi9IpPTvQy6tER9nO4FatU=
MIME-Version: 1.0
In-Reply-To: <20090519151815.GD28289@duck.suse.cz>
References: <f5a7b3810905160458if6ce50en5079fc7f877484ee@mail.gmail.com>
	 <20090518121153.GA25232@duck.suse.cz>
	 <f5a7b3810905190327r2cfa84feka3abb3f57c5b24bc@mail.gmail.com>
	 <20090519151815.GD28289@duck.suse.cz>
Date: Thu, 4 Jun 2009 21:45:44 +0530
Message-ID: <f5a7b3810906040915u12dc3e44t13fa68a58e7b0166@mail.gmail.com>
Subject: Re: quotactl ERANGE man page update
From: naresh kamboju <naresh.kernel@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: mtk-manpages@gmx.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan Kara,

please give me the URL or path that you have updated about quotactl  ERANGE.

Thanks
naresh

On Tue, May 19, 2009 at 8:48 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 19-05-09 15:57:48, naresh kamboju wrote:
>> Hi,
>>
>> >> So could you update the quotactl man page w.r.t if_dqblk.dqb_valid
>> >  Thanks for reminder. I've updated manpage distributed with quota-tools
>> > accordingly.
>> > --
>> > Jan Kara <jack@suse.cz>
>>
>> Thanks for your update.
>> May I know when history-header-section of files will be modified?
>> (fs/quota/dquot.c)
>  Probably never. We use changelogs in git now.
>
>> Is there any modification in Documentation-section
>> required?(Documentation/filesystems/quota.txt)
>  No, because it documents just netlink interface. The rest is either in
> quota tools documentation or in man pages.
>
>                                                                        Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
