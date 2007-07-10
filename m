Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbXGJPIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbXGJPIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbXGJPIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:08:30 -0400
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:23861 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754326AbXGJPI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:08:29 -0400
X-YMail-OSG: YyPMb44VM1ll2lW8kHi9cpRzByX.yfseO4B.csKItEH8UqW.Nc.1.3DttMt_3Ob2or9O58xwkA--
Date: Tue, 10 Jul 2007 10:08:26 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morgan <morgan@kernel.org>
Subject: Re: -mm merge plans for 2.6.23
Message-ID: <20070710150826.GA32147@vino.hallyn.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
...
> implement-file-posix-capabilities.patch
> implement-file-posix-capabilities-fix.patch
> file-capabilities-introduce-cap_setfcap.patch
> file-capabilities-get_file_caps-cleanups.patch
> file-caps-update-selinux-xattr-hooks.patch
> 
>  file-caps seems to be stuck.  There has been some movement lately, might
>  merge it subject to suiable acks from suitable parties.

Andrew Morgan has requested a series of changes.  Since one of these
would involve a change in the on-disk format of file capabilities, I
guess these should (sigh) wait another cycle.

I will try to get that change out the door next, as soon as possible, so
that hopefully there are no more definite blocking requests.

thanks,
-serge
