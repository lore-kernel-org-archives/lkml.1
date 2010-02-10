Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0BJBA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:00:56 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:60914 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab0BJBAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:00:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jnRwazzeeOBV9wAL68Iu9mIzV9nyIiowKlBARptyKA1C0AlYRtbdjhElM4O7gxgHyV
         idXYO1bSKQHed+kWPdBXCZVMutKmEE+Qtbh7vLjNx02hVxtgMBw+w240iIMpTci6F3bo
         O/5iLriJ+N9obopvR/wj0ig4z2YSkOJgL3+ws=
MIME-Version: 1.0
In-Reply-To: <1265762839.2131.46.camel@Joe-Laptop.home>
References: <1265762223-21006-1-git-send-email-richih.mailinglist@gmail.com>
	 <1265762839.2131.46.camel@Joe-Laptop.home>
Date: Wed, 10 Feb 2010 02:00:52 +0100
Message-ID: <2d460de71002091700k1d48b5d3oec7be8a3e597d89f@mail.gmail.com>
Subject: Re: [PATCH 1/1] SCRIPTS: Fix whitespace in get_maintainer output
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-crypto@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 01:47, Joe Perches <joe@perches.com> wrote:

> One space not two after periods?  Horrors.

Not quite, but still wrong and worthy of a fix :)

For what it's worth, applying it would take less time than the
sending and reading of these two emails ;)


Still, any feedback is good feedback.

Thanks,
Richard
