Return-Path: <linux-kernel-owner+w=401wt.eu-S1762789AbXJNRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762789AbXJNRwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761424AbXJNRvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:51:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:1926 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382AbXJNRu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:50:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=BoUKTeZTHlbTn+4A1C45Zugy7h2w1mKoDHjk2YSgHun7NTGJgRNzQtBNYssS6mdnvVu6TMCg3t8mrdiyr6gg1NcpmjWfsZ31WcmfQwfYaaxWmrVsU/3p8diUtZ5pDPZF+T6SGP/iJiJtM/Lt9odUT2htVtn+HG8ywqsSx7I63kQ=
Message-ID: <47125633.3030404@googlemail.com>
Date: Sun, 14 Oct 2007 19:47:31 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
References: <200710141558.27156.vda.linux@googlemail.com>
In-Reply-To: <200710141558.27156.vda.linux@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> Hi,

Hi,

> Compile tested and applies cleanly to 2.6.23.
> I don't have this hardware anymore and cannot run test these patches.

I can test these patches on an aic7892 controller later on today if you want.

BTW while you seems to care about this driver could you have a look at :

http://bugzilla.kernel.org/show_bug.cgi?id=3062 ?!?


Regards,

Gabriel C

