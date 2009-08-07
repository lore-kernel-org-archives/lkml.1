Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbZHGNrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbZHGNrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 09:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbZHGNrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 09:47:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:64189 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079AbZHGNrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 09:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tjQ0QhG1TqyOUeqShhqGD5/vrLc1nqMxON7UsVXIDQVHHLUpeGq1HX64Z9Hm+bgqrM
         9lc4kHfva+QfCTAuLDA52ROnpnpPiX3G7S6P8nDh1v/bBUYX3v4dnjW6/w8r+LUoG2NF
         cKuHUhFL3FgbIX0uUjROeek6IGmUYFumIN94k=
Date: Fri, 7 Aug 2009 21:47:00 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-08-06-00-30 uploaded
Message-ID: <20090807134659.GA2093@darkstar>
References: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, andrew

Booting with this release, init (maybe getty?) reports something like:

INIT: open /dev/console failed with input/output error

2.6.31-rc5 is fine.

Any hints to find the root problem?

Another problem:

When I moving mouse or pressing key the screen will become black, then restore the normal screen.

--
Regards
dave
