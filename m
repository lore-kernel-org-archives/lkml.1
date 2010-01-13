Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356Ab0AMCzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0AMCzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 21:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694Ab0AMCzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 21:55:47 -0500
Received: from mail-qy0-f202.google.com ([209.85.221.202]:55111 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab0AMCzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 21:55:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yFYt/G0QJ+H2TvdxQQ20LsRQkR5sUnmIJ0Q4Fz+CcMu39LADp9YGgMybgTnNpDptL3
         Od4uanMnhls7iQVihvICi9/c5jFej6/AHnfrgDOpUBRaSH/SGZ00yJFKIhZKmmsm7iPs
         Y4z3Jo290zFN39LqvtC41aeCTo/6P4m4WyGzE=
MIME-Version: 1.0
In-Reply-To: <CXIfLt-ygXM.A.zyB.vglSLB@chimera>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
	 <CXIfLt-ygXM.A.zyB.vglSLB@chimera>
Date: Wed, 13 Jan 2010 10:55:34 +0800
Message-ID: <2375c9f91001121855j2884e594nd6f9801231c1bb83@mail.gmail.com>
Subject: Re: [Bug #14903] Kernel panic - not syncing: Attempted to kill init!
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Zhiyong Wu <zwu.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 6:56 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14903
> Subject         : Kernel panic - not syncing: Attempted to kill init!
> Submitter       : Zhiyong Wu <zwu.kernel@gmail.com>
> Date            : 2009-12-18 4:08 (24 days old)
> References      : http://marc.info/?l=linux-kernel&m=126110931124738&w=4
> Handled-By      : Américo Wang <xiyou.wangcong@gmail.com>
>

Hi,

I don't think this is a kernel problem, it should be a problem of Zhiyong's
initrd, or Zhiyong may not configure his kernel properly, in any case,
this is not a bug of kernel.

Thanks.
