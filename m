Return-Path: <linux-kernel-owner+w=401wt.eu-S1758406AbZIPNyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbZIPNyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbZIPNyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:54:08 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:50166 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZIPNyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=A2Edi0Evu2iSsbnFPbxye/I2zuKUZ8eAJ+xBiqxCgDFfR1LbNsjRI/tHCKaBRV8D9u
         3W1x6kZ9NRdeHWuSKYzX/G+R+lwuZXIM53F9ztntd5L7xLe/eOzckPvyqcA780fAew/E
         xvaReW6OBMT89tBMj0haDkUJGsEytmBFYxh48=
MIME-Version: 1.0
In-Reply-To: <84144f020909160543s38daa8ebs989b9da09802d681@mail.gmail.com>
References: <20090916120529.GB18050@centrinvest.ru>
	 <1253103989-25635-1-git-send-email-andy.shevchenko@gmail.com>
	 <84144f020909160543s38daa8ebs989b9da09802d681@mail.gmail.com>
Date: Wed, 16 Sep 2009 16:54:08 +0300
Message-ID: <5ec8ebd50909160654k2670fa48ue4a553a5ed42bbaa@mail.gmail.com>
Subject: Re: [PATCH v2] media: video: pwc: Use kernel's simple_strtol()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 3:43 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> What's with all the casting to int?
Yeah, you are right, they are redundant. See next iteration of the patch :-)

-- 
With Best Regards,
Andy Shevchenko
