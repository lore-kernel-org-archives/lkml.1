Return-Path: <linux-kernel-owner+w=401wt.eu-S1762227AbXIZUw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762227AbXIZUw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762087AbXIZUwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:52:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:49110 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbXIZUwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:52:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=pydJblzEP19dQIw9GUDwaZcJCqGp0hBf/t62jZWersUOgOCG1aIdeZHMrreBXixH1YhPw+XNU5n5g0pjBcAZQesqNpXJwZlEvbF7cE8jjs0/f7UF2GDEfHlfIuurCVh0Rl1mBRDkLz7RY1hNiAqfnYyzdOyKim0oWj15kIHa73o=
Date: Wed, 26 Sep 2007 16:52:30 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>, nigel@suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       linux-pm@lists.linux-foundation.org,
       huang ying <huang.ying.caritas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Message-ID: <20070926205229.GG31759@nineveh.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Kyle Moffett <mrmacman_g4@mac.com>,
	Jeremy Maitin-Shepard <jbms@cmu.edu>,
	Alan Stern <stern@rowland.harvard.edu>,
	Nigel Cunningham <nigel@nigel.suspend2.net>, nigel@suspend2.net,
	Kexec Mailing List <kexec@lists.infradead.org>,
	linux-kernel@vger.kernel.org,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	linux-pm@lists.linux-foundation.org,
	huang ying <huang.ying.caritas@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0709211540100.5816-100000@iolanthe.rowland.org> <200709221234.18426.rjw@sisk.pl> <3BCF760C-D77D-417A-809A-B20D04DD01D3@mac.com> <200709222351.32137.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709222351.32137.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    FWIW, on all the hardware I have, Windows is able to deal with:

    (1) hibernate Windows
    (2) run $(OTHER_OS)
    (3) resume Windows

... which seems to me to say that Linux is doing it wrong if it can't
handle other ACPI users between hibernate and resume.  But maybe
that's just my hardware.

--
Joseph Fannin
jfannin@gmail.com
