Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416AbZKREA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbZKREA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 23:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbZKREAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 23:00:55 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35987 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbZKREAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 23:00:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ESDimgA8zo8Exxr5+E2/wrXH9/NPkzhXfLkFMqYajsRhGZRTuKBdWX8wsgBjTB+NWN
         DCC/dRHuzgWrO+WtQSuphuG4TUPAOpKNCSsNjuTO0CMT/NhzKUTCB+EIlEaLKV5D+jun
         uoJdzEmTha3Dw2zj1U355u+4xGKyF4VtZFG1I=
Message-ID: <4B037177.7060501@gmail.com>
Date: Tue, 17 Nov 2009 23:00:55 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: huananhu@huawei.com, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/11]Optimize the upload speed for PPP connection.
References: <faf197be196ee.196eefaf197be@huawei.com> <20091117.012248.86306050.davem@davemloft.net>            <4B0278D9.6030806@gmail.com> <13129.1258483787@turing-police.cc.vt.edu>
In-Reply-To: <13129.1258483787@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> The '-- ' *convention* isn't even at the next layer up, MIME.  If anything,
> it's out at the liveware level (though some MUAs provide code to make it
> a bit easier to deal with...)
> 
Hey Valdis, nice to hear from you....


> (Feel free to cite RFC chapter-and-verse if you disagree, and note that
> 'Informational' RFCs are never standards. ;)
> 
Yeah, a quick check shows it's mentioned in MIME RFC-1341 (June 1992), but
certainly going back to "Proposed standard for message encapsulation"
RFC-934 (January 1985) at the very least.  I seem to remember that Marshall
or Stef or somebody used it for digest sections too, but don't remember the
RFC number or a good search term.

Still, (relevance here) a convention observed for patches.
