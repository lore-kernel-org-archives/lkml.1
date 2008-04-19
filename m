Return-Path: <linux-kernel-owner+w=401wt.eu-S1761823AbYDSOXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761823AbYDSOXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 10:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbYDSOXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 10:23:37 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:65044 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542AbYDSOXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 10:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jwRCyZ2pY2hx5vw4yQRdOMz0GUk0pe6Ry2qXSTM+1JAcMRRtR2PXjLPPlMzQ7G0/J3nNSwNuHqeW21mEF1r3DafeWW2Z9T82EO4UARVCYRsP8OneGc2j3ui7ieKomkl/Me5tpEQAyqYXFZ2gG0jE6eRyW10aV4uCYyCLvdXdbbE=
Message-ID: <dd18b0c30804190723t64779e7rdbacbda2e76349@mail.gmail.com>
Date: Sat, 19 Apr 2008 07:23:35 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: devzero@web.de
Subject: Re: latest git freezes my system
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <245581241@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <245581241@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 2:18 AM,  <devzero@web.de> wrote:
> what was the last working kernel/config for you?
>  if an earlier kernels work without problems, then it`s a regression
>  can you switch to kernel log console before the freeze and wait for it to happen?
>  any message/oops/panic there?
>  does the system respond to sysrq after the freeze ? (http://linuxgazette.net/issue81/vikas.html )
>
>  roland
>
>
>  List:       linux-kernel
>  Subject:    latest git freezes my system
>  From:       "Justin Mattock" <justinmattock () gmail ! com>
>  Date:       2008-04-19 7:23:14
>  Message-ID: dd18b0c30804190023ka240e30u27f20fcbf4295a35 () mail ! gmail ! com
>  [Download message RAW]
>
>
>
>  I updated the latest git 2.6.25-02519-g3925e6f on my macbook pro, and
>  I seem to experiencing a system freeze on a given random number, i.g.
>  The system will run for five minuetes no problem, then a system
>  freeze, or during the boot process when the systems try's to load the
>  modules I'll receive a freeze
>  or I'll get the system up then within minuetes. Is there something I
>  need to add to my .config, or is this something more complex.
>  Also I'm seeing a no module symbols loaded kernel modules not enabled,
>  in /var/log/kern.log;  could this be related.
>  any help would be appreciated..
>
>  --
>  Justin P. Mattock
>
>  __________________________________________________
>  GRATIS: Movie-FLAT. Jetzt freischalten!
>  http://freemail.web.de/club/maxdome.htm/?mc=025557
>
>

Hello, Yes the last .config worked fine for me. I can go ahead and try
what you had said, and see if I receive any info on why I there is a
freeze.
regards;


-- 
Justin P. Mattock
