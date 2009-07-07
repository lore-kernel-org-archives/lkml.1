Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbZGGUl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbZGGUl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbZGGUlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:41:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36181 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbZGGUlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:41:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: 2.6.31-rc2: Reported regressions from 2.6.30
Date: Tue, 7 Jul 2009 22:41:52 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, bunk@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <200907072125.47762.elendil@planet.nl>
In-Reply-To: <200907072125.47762.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907072241.53505.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Frans Pop wrote:
> > If you know of any other unresolved regressions from 2.6.30, please let
> > me know either and I'll add them to the list.
> 
> Please add: http://lkml.org/lkml/2009/6/29/88
> 
> Reinette Chatre is handling the bug and posted a patch in 
> http://lkml.org/lkml/2009/6/30/224

Added as http://bugzilla.kernel.org/show_bug.cgi?id=13742.

Thanks,
Rafael
