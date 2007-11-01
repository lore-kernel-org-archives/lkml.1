Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbXKACUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbXKACUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 22:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXKACUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 22:20:23 -0400
Received: from web36614.mail.mud.yahoo.com ([209.191.85.31]:21113 "HELO
	web36614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754558AbXKACUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 22:20:21 -0400
X-YMail-OSG: Gpwz9IoVM1mx0TXkBY2vGBLgaSepj6RqTc.TbhFZfXjE55ZXtODceFiMZmD_amR7N5h7b2uZ1A--
X-RocketYMMF: rancidfat
Date: Wed, 31 Oct 2007 19:20:20 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
To: Peter Dolding <oiaohm@gmail.com>, Toshiharu Harada <haradats@gmail.com>
Cc: Crispin Cowan <crispin@crispincowan.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <e7d8f83e0710311904w45827586oabcca597fd612ea6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <832119.21078.qm@web36614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Peter Dolding <oiaohm@gmail.com> wrote:


> Improvements to the single security framework are getting over looked.

Please post proposed patches.

>   I would have personally though selinux would have done Posix file
> capabilities as a general service to all.

Posix capabilities predate SELinux. SELinux is not interested in
Posix capabilities. 

> But no IBM had to do it.

Err, no. It was done by Andrew Morgan back in the dark ages.
Why on earth do you think IBM did it?

> ...

OK, you have all the answers. Show us some code or STFU.


Casey Schaufler
casey@schaufler-ca.com
