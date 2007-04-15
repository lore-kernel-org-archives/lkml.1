Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbXDOKVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbXDOKVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 06:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXDOKVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 06:21:51 -0400
Received: from holomorphy.com ([66.93.40.71]:42443 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbXDOKVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 06:21:51 -0400
Date: Sun, 15 Apr 2007 03:21:57 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Maxim Uvarov <muvarov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       davidsen@tmr.com, randy.dunlap@oracle.com, dada1@cosmosbay.com,
       Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Re: Performance Stats: Kernel patch
Message-ID: <20070415102157.GB2986@holomorphy.com>
References: <461A4C1E.3070309@ru.mvista.com> <20070415094706.GB10097@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415094706.GB10097@ucw.cz>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At some point in the past, someone's attribution was stripped from:
>> +       return buffer + sprintf(buffer, "Nvcsw:\t%lu\n"
>> +                           "Nivcsw:\t%lu\n",
>> +                           p->nvcsw,
>> +                           p->nivcsw);

On Sun, Apr 15, 2007 at 09:47:07AM +0000, Pavel Machek wrote:
> We don't encrypt variable names like this.

nvcsw and nivcsw are conventional variable names for these quantities.


-- wli
