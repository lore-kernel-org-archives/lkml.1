Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYL2MVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYL2MVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYL2MVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:21:23 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:50545 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbYL2MVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nWUoxBhKvzcW2+EO1OAIkbHyPA/9ihPr+xTQkdYOtJ3yY35BJuA33LaX1IVsEok+U7
         ua7Ispzvul0c1+hr11TP5bdIZ2RyM7QkmMtfpYU2ugnf+8iC4MeM2QG6htkqaA2cLeBe
         UMSAf8Gkqer+c2DtnYCLplfHeBU4vA9nslHdo=
Message-ID: <8bd0f97a0812290421w370785f2w9cfaf609f9f096ff@mail.gmail.com>
Date: Mon, 29 Dec 2008 07:21:21 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/map_to_7segment.h: convert to __inline__ for userspace
Cc: anemo@mba.ocn.ne.jp, dtor@mail.ru, henk.vergonet@gmail.com
In-Reply-To: <1230360687-6739-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230360687-6739-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 01:51, Mike Frysinger <vapier@gentoo.org> wrote:
> Use __inline__ rather than inline for map_to_seg7() since it is exported
> to userspace.

this patch can be ignored due to the autoconvert patch proposed for
headers_install.pl
-mike
