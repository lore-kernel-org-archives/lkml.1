Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbYAVNkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbYAVNkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 08:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYAVNkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 08:40:10 -0500
Received: from main.gmane.org ([80.91.229.2]:41784 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbYAVNkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 08:40:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Giulio <giulioo@pobox.com>
Subject: Re: [PATCH for mm] Remove iBCS support
Date: Tue, 22 Jan 2008 14:20:44 +0100
Organization: unknown
Message-ID: <fn4qjc$fl5$1@ger.gmane.org>
References: <20080119045918.GA12215@basil.nowhere.org> <4792B191.2060801@davidnewall.com> <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 213.255.43.90
X-Newsreader: Forte Agent 4.2/32.1117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:

>> I think I do.  You appear to be arguing that small businesses, such as
>> paint shops or garages, could re-install iBCS2 support. 
>
>You seem to be under the illusion that iBCS2 support works currently
>in mainline and that only this patch would break it. That's not 
>the case.
>
>It's a significant patchkit that was only available in 2.4 and is
>now missing a lot of infrastructure and would probably be significant

AFAIK ibcs is fully functional in 2.6 via external modules (no patch
needed).
http://downloads.sourceforge.net/linux-abi/ibcs-3_4.tgz

If your proposed change goes in, I think a patch will be necessary (ie no
more kmod-ibcs-.....)
-- 
giulioo@pobox.com

