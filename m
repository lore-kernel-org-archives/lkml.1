Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZESK14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZESK14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbZESK1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:27:48 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:7017 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZESK1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dXeKDLpLazcawlE8GKokvHQICC129E/A2Y0xVNkXSB+rHhCYbu7++RB2ZjBdny2FWG
         j2yyRqI/ZLtHThpaoCe61yo1ti+0Og6JyQL/eWXSIKKQgABKVIUZMB4cW7AmFG6z48Bg
         JI0yX+LxvrYj6jQCigNv33SZsbGvRnapAHCZM=
MIME-Version: 1.0
In-Reply-To: <20090518121153.GA25232@duck.suse.cz>
References: <f5a7b3810905160458if6ce50en5079fc7f877484ee@mail.gmail.com>
	 <20090518121153.GA25232@duck.suse.cz>
Date: Tue, 19 May 2009 15:57:48 +0530
Message-ID: <f5a7b3810905190327r2cfa84feka3abb3f57c5b24bc@mail.gmail.com>
Subject: Re: quotactl ERANGE man page update
From: naresh kamboju <naresh.kernel@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: mtk-manpages@gmx.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> So could you update the quotactl man page w.r.t if_dqblk.dqb_valid
>  Thanks for reminder. I've updated manpage distributed with quota-tools
> accordingly.
> --
> Jan Kara <jack@suse.cz>

Thanks for your update.
May I know when history-header-section of files will be modified?
(fs/quota/dquot.c)
Is there any modification in Documentation-section
required?(Documentation/filesystems/quota.txt)

Best wishes,
Naresh Kamboju
