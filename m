Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab0AORMT (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 12:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757852Ab0AORMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 12:12:18 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:61032 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab0AORMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 12:12:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WjyKRSl94L0FeF+5Wt3FdYJgZFH+NgBs8CXizTiS4LYIQJLOu5EDU8GF5yd5qLze6Z
         17vvWNyZGeIggT9nVGwj9ZHOMAGGy9fFm02wnnUkL+WDLf5/Csnfc0qm/AGctIm1+Dze
         +j2VXUnXY3hm6/oX0FfhTPkwQwAgVprUA+aYM=
Message-ID: <4B50A1EB.2030903@lwfinger.net>
Date: Fri, 15 Jan 2010 11:12:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
CC: linux-kernel@vger.kernel.org, Stefano Brivio <stefano.brivio@polimi.it>,
        linux-wireless@vger.kernel.org,
        Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: [PATCH] obsolete in kernel source (B43_LEGACY_RFKILL)
References: <20100113135937.GA5588@stud.informatik.uni-erlangen.de>
In-Reply-To: <20100113135937.GA5588@stud.informatik.uni-erlangen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 07:59 AM, Christoph Egger wrote:
> 
> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.

The patch is in wireless-testing as commit
2f1f00fc9b477481ad5c63976385c345851fee3d. It will be in mainline kernel 2.6.34.

Larry
