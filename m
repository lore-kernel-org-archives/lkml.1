Return-Path: <linux-kernel-owner+w=401wt.eu-S1161014AbXBBAv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161014AbXBBAv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 19:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161025AbXBBAv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 19:51:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:6589 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161014AbXBBAvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 19:51:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ixBFM70OfdswNjDLgjEJ7WTwpVzopfhmzw2Omq0e3Xt6zfrO5nsmOnTlSGX0Kqwc4C/wknA/gD3y93z6vch4zNk47la196pX5qyEnOmrUxMvU289w8Rpb5+eovL2UpN7Z2hCGul8/kXBZlcIUVstoat03daQgmx80Gw1lJwInms=
Message-ID: <3d57814d0702011651s5d5f9dafuc26369fab99ad5cf@mail.gmail.com>
Date: Fri, 2 Feb 2007 10:51:23 +1000
From: "Trent Waddington" <trent.waddington@gmail.com>
To: "Tomas Carnecky" <tom@dbservice.com>
Subject: Re: [PATCH] Ban module license tag string termination trick
Cc: "Jon Masters" <jonathan@jonmasters.org>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>
In-Reply-To: <45C2832F.10603@dbservice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.61.0611011204140.23977@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr>
	 <45C2670F.5000003@jonmasters.org> <45C2832F.10603@dbservice.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/07, Tomas Carnecky <tom@dbservice.com> wrote:
> Can't you put this somewhere into the documentation: it's our kernel,
> play by our rules, and our rules are, the license is what is visible in
> 'printf(license)'?

Here I was thinking the rules were: all modules must be GPL and the
jerks who make proprietary modules are just blatantly breaking the
law.  But you're right, the MODULE_LICENSE tag really does imply that
licenses other than the GPL are ok.

Trent
