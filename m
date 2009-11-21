Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZKURrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZKURrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 12:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbZKURrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 12:47:35 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40975 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573AbZKURre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 12:47:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=LI/RxhjHst/TyyqHwkx+I5+5Z+RKg4Tef/N2nGONtgmGuSBXJXgLLoFDC3dXQaEomF
         fVGPitc1uTUyV+mZwb+ANSAGjXYKt9267q2iw7gRAytBv2Jrrwf+ZJ6eF8GpowRZ7mgK
         tCg4Bmza1jV26OKAEOQs0ZCX/KxQY6tzwrf6k=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <mYW9sxtWd2G.A.D7G.GFACLB@chimera>
References: <7qTjLRFNcGF.A.eSE.kCACLB@chimera>
	 <mYW9sxtWd2G.A.D7G.GFACLB@chimera>
Date: Sat, 21 Nov 2009 19:47:39 +0200
X-Google-Sender-Auth: 38c758387d2613bd
Message-ID: <11fae7c70911210947t6b9e0bbdx2c7f5c252977f4f9@mail.gmail.com>
Subject: Re: [Bug #13941] x86 Geode issue
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, it is not resolved.

Attachments have been recently added to the bug and it would be highly
desirable for whoever introduced those regressions in 2.6.31 to
examine them and participate in resolving the issue. Alternately,
reverting those ACL caching changes to 2.6.30 status would be equally
acceptable as a solution.
