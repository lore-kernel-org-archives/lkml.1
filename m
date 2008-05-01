Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbYEAMEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbYEAMEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbYEAMD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:03:56 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:34320 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391AbYEAMDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:03:55 -0400
Date: Thu, 1 May 2008 13:04:05 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problems with -git14
In-Reply-To: <20080430214045.78c307d9@werewolf.home>
Message-ID: <Pine.LNX.4.64.0805011255500.19626@blonde.site>
References: <20080430015655.5a42f63d@werewolf.home>
 <Pine.LNX.4.64.0804301516580.30549@blonde.site> <20080430214045.78c307d9@werewolf.home>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-490663057-1209643445=:19626"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-490663057-1209643445=:19626
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 30 Apr 2008, J.A. Magall=C3=B3n wrote:
> > >=20
> > > (dual Xeon HT)
=2E..
>=20
> One question that always bugs me: do I have to set NR_CPUS=3D8 to pick
> apicid number 7, and let the map just flag the ones I have,

No, that would be unbearable (few understand the logic of those ids).

> or will it work with NR_CPUS=3D4 ?

Yes, that works (and it's intended to work that way).

Hugh
--8323584-490663057-1209643445=:19626--
