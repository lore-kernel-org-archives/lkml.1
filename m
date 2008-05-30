Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbYE3OCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbYE3OCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 10:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYE3OCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 10:02:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:1079 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYE3OCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 10:02:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s609OHnPh2WNi7d1w7Rtej/O28NvmkZXokY0N6xu3rbNgaaDgMOCZ8FFv/MxdMejHkBEFYOE1Y3sCydy95C+RcWi61ReuJQ1Y4QfNhr2Na7YBDdGo4+PE4aSqCIkchxNQYjVxhvGZDUH98g3WSWNjyKN3Upify1UT18ANSMIFag=
Message-ID: <961aa3350805300702p23c3a7f0v4fcffcfe6d3ac9ca@mail.gmail.com>
Date: Fri, 30 May 2008 23:02:05 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: devzero@web.de
Subject: Re: [PATCH] edd: fix error paths in module_init
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <297064421@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <297064421@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> it looks that your patch is fixing this one :
>
> https://bugzilla.novell.com/show_bug.cgi?id=394571
> https://bugzilla.novell.com/attachment.cgi?id=218198
>
> i didn`t yet try, but maybe you are able to take a look and confirm ?
>
> if this is correct - how did you manage looking two days into the future ? ;)

yep, the patch must fix this bug.
