Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbXDDUsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbXDDUsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbXDDUst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:48:49 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:58401 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbXDDUss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:48:48 -0400
Date: Wed, 4 Apr 2007 22:45:53 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Aaron Lehmann <aaronl@vitelus.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jim Paris <jim@jtan.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Silent corruption with r8169
Message-ID: <20070404204553.GD7814@electric-eye.fr.zoreil.com>
References: <20070401012736.GT15189@vitelus.com> <20070401030315.GA24080@jim.sh> <20070401043905.GV15189@vitelus.com> <p737iswqjq4.fsf@bingen.suse.de> <20070404184504.GB7814@electric-eye.fr.zoreil.com> <20070404200603.GX15189@vitelus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404200603.GX15189@vitelus.com>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron Lehmann <aaronl@vitelus.com> :
[...]
> I'll try to get to testing this, but I'm wondering if people may have
> misunderstood my original post. I don't get any corruption over
> Ethernet; it's just corruption on the filesystem during certain load
> patterns that involve the Realtek ethernet card.

It is too soon to label it a debug feature or a genuine bug in the
r8169 driver but at least there is a r8169 patchkit to help with
various annoyances (obscure bug on amd platform for instance).
It could make a difference.

The disk io + r8169 driver bugs can be very frustrating to debug :o/

-- 
Ueimor

Anybody got a battery for my Ultra 10 ?
