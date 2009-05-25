Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZEYI24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZEYI24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZEYI2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:28:49 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:34617 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbZEYI2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:28:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yHmml9+lxsQZhZpDDZVROi/m1AhYBiUQsysJfOLw1RgySiJWT8TygQoMsm4bY8iKwI
         HGazr5JHl4mJgIeV/j/+fKTrMxxiRafqR76a1V1IaROqg6SWmUwdb9OHPeDU+m4Hh0M2
         nBM2oeic9xbpGw3GZrrWv62H0omu9ILbsGOCw=
MIME-Version: 1.0
In-Reply-To: <20090525082550.GA6240@sortiz.org>
References: <63386a3d0905211417h625853bdkb733a0827753c9bc@mail.gmail.com>
	 <20090525082550.GA6240@sortiz.org>
Date: Mon, 25 May 2009 10:28:48 +0200
Message-ID: <63386a3d0905250128u1f956bfdg2c92c1d21f9b915b@mail.gmail.com>
Subject: Re: [PATCH 1/1] MFD: Add U300 AB3100 core support v5
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/25 Samuel Ortiz <sameo@linux.intel.com>:

> I'm happy with this one, thanks a lot.
> Applied to my for-next branch.

Thanks a lot Sam, and also thanks again and again to everyone who helped
out reviewing this driver, especially Mike Rapoport who took the time to teach
me some important lessons on MFD driver style.

Yours,
Linus Walleij
