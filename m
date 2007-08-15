Return-Path: <linux-kernel-owner+w=401wt.eu-S934690AbXHOThp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934690AbXHOThp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 15:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbXHOThg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 15:37:36 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:46413 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbXHOThf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 15:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HiV0Fa52x2//LJTwAMq9pvRs7BJtOTCrTY9SPODnkOc/HcuTDcs4TTQX1U7QQ1BGK8SoWiM2xY9Hm/eHvsnW3O4OV2NFxphVjWHH9UUpBhHrTz6PuqSAijom7Bl3wz+nkmbFDKzwZB3KOAk717oxl4Syg5lJol7OD5hFPozssLI=
Message-ID: <46C3562F.1040702@gmail.com>
Date: Wed, 15 Aug 2007 21:38:23 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: postfail@hushmail.com
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH 4 of 5 ] /drivers/char/rio ioremap balancing/ returncode
 check
References: <20070814040141.5EE75DA81F@mailserver7.hushmail.com>
In-Reply-To: <20070814040141.5EE75DA81F@mailserver7.hushmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Thompson napsal(a):
> On Mon, 13 Aug 2007 16:30:14 -0400 Jiri Slaby <jirislaby@gmail.com> 
> wrote:
>> why dri-devel@lists.sourceforge.net?
>>
> 
> David Airlie was listed as the owner on several of the files and in 
> maintainers for "DRM", which was my best to: guess for 
> /drivers/char/drm (which was patch 3 in this series).
> 
> If there was a better list, or just to linux-kernel, please let me 
> know as tracking down the 'right' list for these kernel-janitor 
> kind of tasks can be tricky....

Ok. I was just curious, why did you CC drm people for char drivers changes.

BTW. is there anybody on janitors list, who collects all those patches and
forwards them upstream?

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
