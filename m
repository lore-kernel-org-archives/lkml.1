Return-Path: <linux-kernel-owner+w=401wt.eu-S1761620AbYEASIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761620AbYEASIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761581AbYEASHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:07:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761575AbYEASHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:07:38 -0400
Message-ID: <481A06C0.6070500@zytor.com>
Date: Thu, 01 May 2008 11:06:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Oliver Hartkopp <oliver@hartkopp.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel naming convention in the merge phase
References: <4818F093.3070105@hartkopp.net> <4819050C.9060800@zytor.com> <48198873.7030503@hartkopp.net>
In-Reply-To: <48198873.7030503@hartkopp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Hartkopp wrote:
> 
> Hm - if it breaks the robotic stuff, there could be a real 
> "v2.6.26-merge" git tag which shouldn't break like "v2.6.26-rc1".
> 

Most of the robots don't have access to git.

> For me a 2.6.25-gitX looks like a snapshot that leads to a 2.6.25.1 and 
> _not_ to a 2.6.26-rc1.

Tough.  It's a naming convention quite old (we had -bk before -git, too.)

	-hpa
