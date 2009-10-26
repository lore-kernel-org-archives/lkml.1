Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbZJZVjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbZJZVjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbZJZVji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:39:38 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57318 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbZJZVjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:39:37 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2009 17:39:37 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=H42PYulCdqtIuVZKnyImK4IZWVuhAgsc/IDqfObzQXY/7mMCepRHA4glHEBKG/GWN9
         52pn5LBtNCLHTfyVEVtRZuKroeXjPzJU+OrDDwkl4m4esioXBgkJlr9anPAbygFukWrW
         ks2ZURw0T1a8sD9UugYPjVSDNf2eyRR4bYhXg=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <vX3ILojF2dJ.A.Zs.mgf5KB@chimera>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
	 <vX3ILojF2dJ.A.Zs.mgf5KB@chimera>
Date: Mon, 26 Oct 2009 23:32:49 +0200
X-Google-Sender-Auth: ddebbeb67c4a41c8
Message-ID: <11fae7c70910261432w27b39e92ld319487e679fccaa@mail.gmail.com>
Subject: Re: [Bug #13941] x86 Geode issue
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not recall anyone on LKML actually ever doing any work towards
fixing this issue so, yes, it is still open.

On Mon, Oct 26, 2009 at 9:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13941
> Subject         : x86 Geode issue
> Submitter       : Martin-Éric Racine <q-funk@iki.fi>
> Date            : 2009-08-03 12:58 (85 days old)
> References      : http://marc.info/?l=linux-kernel&m=124930434732481&w=4
>
>
>
