Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbZDGV2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbZDGV2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756703AbZDGV2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:28:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56011 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100AbZDGV2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:28:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [Bug #12870] 2.6.29-rc "TKIP: replay detected" regression
Date: Tue, 7 Apr 2009 23:28:21 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <AsKNxFx2juN.A.cV.bGn2JB@chimera> <Pine.LNX.4.64.0904070001400.4254@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0904070001400.4254@blonde.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904072328.22309.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Hugh Dickins wrote:
> On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12870
> > Subject		: 2.6.29-rc "TKIP: replay detected" regression
> > Submitter	: Hugh Dickins <hugh@veritas.com>
> > Date		: 2009-03-11 12:07 (27 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123677337219148&w=4
> > Handled-By	: "John W. Linville" <linville@tuxdriver.com>
> > Patch		: http://marc.info/?l=linux-wireless&m=123678463704691&w=2
> 
> John's fix went into 2.6.29 final: please remove this regression now.

Done.

Thanks,
Rafael
