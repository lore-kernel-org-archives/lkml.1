Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbYJFHNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbYJFHNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 03:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYJFHNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 03:13:30 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:35020 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbYJFHN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 03:13:29 -0400
Date: Mon, 6 Oct 2008 09:12:29 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Greg KH <greg@kroah.com>
Cc: =?unknown-8bit?B?Si5BLiBNYWdhbGzDs24=?= <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Bruno =?unknown-8bit?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       Ivan Vecera <ivecera@redhat.com>
Subject: Re: Update request for r8169
Message-ID: <20081006071229.GA23039@electric-eye.fr.zoreil.com>
References: <20081006021614.1c7fcaff@werewolf.home> <20081006035945.GA26148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081006035945.GA26148@kroah.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> :
> On Mon, Oct 06, 2008 at 02:16:14AM +0200, J.A. Magall?n wrote:
[...]
> > Could someone pick the patchset from
> > http://userweb.kernel.org/~romieu/r8169/2.6.27-rc6/
> > plz ?
> 
> Can you submit them properly as described in
> Documentation/SubmittingPatches?

AFAIK the relevant patches (#0001 ... #0009) are already included in
davem'next tree and should thus appear in 2.6.28-rc1.

can you confirm that they work as expected ?

Btw I'll push Ivan Vecera's MAC address restore and Bruno Prémont WoL
patches too.

-- 
Ueimor
