Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYFKKqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYFKKqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 06:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbYFKKqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 06:46:03 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:31331 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbYFKKqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 06:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pIKGCPnMXNRm9Km5Wh5JlSW7BxJjh2gcyz83eqtLA/P3OzZcjgkJDelAwgp2WpNZAp
         WFTT5hy8nwVObL/zCLYJgB+QGUxRmPvwHzW5nHxC4SH8Pur2NRSzllh7HOXghJAHmCuI
         Y6iK7UKlgL+3cQVtcqa7fP4oUoxYthEeii64A=
Message-ID: <87a5b0800806110345v77529fc8r591f2fb4c95b5bdf@mail.gmail.com>
Date: Wed, 11 Jun 2008 11:45:55 +0100
From: "Will Newton" <will.newton@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [ANNOUNCE] linux-staging tree created
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors@vger.kernel.org, linux-next@vger.kernel.org,
       "Stephen Rothwell" <sfr@canb.auug.org.au>
In-Reply-To: <20080610190540.GA25066@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080610190540.GA25066@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 8:05 PM, Greg KH <greg@kroah.com> wrote:

> This tree will be included in the daily linux-next builds, and will get
> testing by all users of that tree.
>
> The rules of what can be included here is as follows:
>        - the code must be released under a Linux kernel-compatible
>          license
>        - the goal of the developers must be to merge this code into the
>          main kernel tree in the near future, but not for the next
>          kernel release.
>        - the code must build properly on the x86 platform
>        - this is not a tree for bugfixes or rewrites of existing kernel
>          code, this should be for new features, drivers, and
>          filesystems.
>        - the patches included must detail exactly what is needed to be
>          completed in order for them to be included into the main
>          kernel tree.
>        - there must be some email address associated with the patch
>          that can be used for bug reporting and questions about
>          cleanups and testing the code.
>
> What this tree is not:
>        - it is not a place to dump features that are being actively
>          developed by a community of people (reiserfs4 for example.)
>        - it is not a place to dump code and then run away, hoping that
>          someone else will do the cleanup work for you.  While there
>          are developers available to do this kind of work, you need to
>          get someone to agree to "babysit" the code.

Would the linux-staging tree be an appropriate place to merge a new
architecture? Or would that be too large a change and should go via
its own tree?
