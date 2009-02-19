Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbZBSPwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbZBSPwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 10:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZBSPwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 10:52:33 -0500
Received: from physics.harvard.edu ([128.103.101.20]:51768 "EHLO
	physics.harvard.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZBSPwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 10:52:33 -0500
From: Andy Neitzke <neitzke@physics.harvard.edu>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: unable to shut down cleanly with 2.6.29-rc (can't remove snd-hda-codec-analog)
Date: Thu, 19 Feb 2009 10:53:42 -0500
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
References: <200902181525.31331.neitzke@physics.harvard.edu> <200902182203.40337.rjw@sisk.pl> <s5h1vtvhqw7.wl%tiwai@suse.de>
In-Reply-To: <s5h1vtvhqw7.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191053.42611.neitzke@physics.harvard.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > With 2.6.29-rc kernels I am unable to shutdown my laptop (Thinkpad
> > X60t) cleanly.
>
> Are you using Gentoo?  See bug #12321.
> 	http://bugzilla.kernel.org/show_bug.cgi?id=12321

Aha, you are absolutely right.  Thank you and sorry for the noise.

Best,

-Andy
