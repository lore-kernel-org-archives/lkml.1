Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYBNKTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYBNKTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 05:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYBNKTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 05:19:25 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:11519 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbYBNKTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 05:19:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eSSWAZn4aoqXnLw7llx2Xa/aW4vfxtWWYGY1Ed/GX6iso7qwn5ab0gGC7/J96ZJqSsiVptDQXgtFPUnqIv45ThOjxPynV67BuIgky8Z8DluUbPddtN9F23YzC0rM/aIsP4SxHc92iWX5YQ61N5rb0C/c+wk0ONSqQLP3p1Phji4=
Message-ID: <40f323d00802140219u73dc010am4cfc9a9a0465f6b@mail.gmail.com>
Date: Thu, 14 Feb 2008 11:19:23 +0100
From: "Benoit Boissinot" <bboissin@gmail.com>
To: "Nick Levinson" <nick_levinson@yahoo.com>
Subject: Re: earlier ctrl-alt-del
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <6267.44656.qm@web33503.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6267.44656.qm@web33503.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 2:10 AM, Nick Levinson <nick_levinson@yahoo.com> wrote:
> Suggestion: ctrl-alt-del should be a working command
>  earlier in the bootup process, so that reboots won't
>  take so long because we have to wait. For example, I
>  sometimes have to change something in BIOS and then
>  must reboot, which means I have to go almost to the
>  login stage before I can warm-reboot.
>
sysrq are working early in the boot process (sysrq s/u/b):
http://lxr.linux.no/linux/Documentation/sysrq.txt

regards,

Benoit
