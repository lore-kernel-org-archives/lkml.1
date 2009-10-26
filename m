Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZJZLuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZJZLuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZJZLuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:50:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:59534 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbZJZLuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:50:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GN29W9Eu568C6LdBgdI0Eqjkzzt9KAwd7pBpCiY4KYhK44uDOsTBLNV8k+V3ARnC6O
         5/PjwCWbUPY5aVwfF0Om71iqzRYMZIgwBjO8qfhZegt3syW7MbW4eyjXoWeS0GS9VaMR
         TUZ5Xch/c09Fm1jXnmu6wvSD4B41hjvrNGTsY=
MIME-Version: 1.0
In-Reply-To: <20091026015755.7482.qmail@stuge.se>
References: <deaa866a0910251546m7ea001bcm252c41e65927a424@mail.gmail.com>
	 <20091026015755.7482.qmail@stuge.se>
Date: Mon, 26 Oct 2009 07:50:54 -0400
Message-ID: <deaa866a0910260450k3eb84fb3j6c8fad4af4598aab@mail.gmail.com>
Subject: Re: Broken ondemand scheduler in Linux 2.6.30+ on Pentium IVs
From: Robert Bradbury <robert.bradbury@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Stuge <peter@stuge.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Peter Stuge was kind enough to point out the Kernel does indeed
have a bugzilla database.  This problem appears to be related to Bug
#14066 though it doesn't appear to have been fixed.  I've seen several
references which seem to suggest there is some other power manager
than the conservative/ondemand/performance options which the Gnome CPU
Frequency Scaling Monitor utility allows you to use to monitor/adjust
the scheduler used.

If there is I'd greatly appreciate someone telling me what it might be.
