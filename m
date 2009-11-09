Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZKIRGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZKIRGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbZKIRGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:06:46 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:39216 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbZKIRGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:06:45 -0500
MIME-Version: 1.0
In-Reply-To: <1257358349.2489.0@antares>
References: <4AF084C6.3020602@nortel.com> <1257358349.2489.0@antares>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 9 Nov 2009 10:06:29 -0700
X-Google-Sender-Auth: fb143c2001bba81b
Message-ID: <fa686aa40911090906pb586592g497de2de50001b5b@mail.gmail.com>
Subject: Re: Fwd: [PATCH] arch/powerpc: Improve _memcpy
To: =?ISO-8859-1?Q?Albrecht_Dre=DF?= <albrecht.dress@arcor.de>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Dirk Eibach <eibach@gdsys.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 11:12 AM, Albrecht Dreﬂ <albrecht.dress@arcor.de> wrote:
> See <http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-May/072582.html>.
> †Any chance to get this one into the tree? †Grant?

Even though it is generic ppc code, I picked it up into my 5200 -next
tree because it's such a simple patch.  I expect Ben will pull it into
his any day now.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
