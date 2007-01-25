Return-Path: <linux-kernel-owner+w=401wt.eu-S932984AbXAYAT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984AbXAYAT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933093AbXAYAT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:19:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:55692 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984AbXAYATz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:19:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L0doBoZeUKTFZ8ZAWOqGAwG/3I6/QLNy3PyZI/uMY6o2dXT5GfFvyzYprVL60OaXhr08ekAXRFMrTPA7x1W5pyBKrEosjXVp4CLNBOPJu+Re8lIozrnKh9ibD3lJZ3XXsStaZ8JqTYAZ2WtAKSfdJnd5yGxRNIVFpyeGMGfNvfs=
Message-ID: <3d57814d0701241619l4b9239fdk78342f08469bbbd7@mail.gmail.com>
Date: Thu, 25 Jan 2007 10:19:52 +1000
From: "Trent Waddington" <trent.waddington@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: [discuss] portmapping sucks
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0701250030530.32656@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.61.0701250030530.32656@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> There are a number of common ports in the 512-1023 range. All
> obsolescence and meaninglessness aside, there _are_ rather "important"
> services in that range, ldaps, rtsp, kerberos, rsync, ftps, imaps, just
> to name a few from /etc/services. This map-to-random-port behavior is a
> total DoS thing.

Any reason why you can't make a one line code change to use a better
range?  Or add a blacklist?

Trent
