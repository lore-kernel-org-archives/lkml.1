Return-Path: <linux-kernel-owner+w=401wt.eu-S1760169AbXHaD5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169AbXHaD5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 23:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbXHaD5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 23:57:18 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:5159 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbXHaD5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 23:57:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=NnSX6quftvnl0XUX8EiC9AySrTqAGfyKlLXaV5kmZosA4HKVNgs0ZOh58XopNBhP+ekxtFORtpiLdt40CTEDj79RSS+tjOFvccQlvL/i+LRMi7zImFyCluMZPWjYFa4wNfYtKQnloZDUm12bGZ9qBBO3SeuBM0tFwpZK4D+UEpw=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Trond Myklebust'" <trond.myklebust@fys.uio.no>,
       "'Frank van Maarseveen'" <frankvm@frankvm.com>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
Subject: RE: recent nfs change causes autofs regression
Date: Thu, 30 Aug 2007 20:57:04 -0700
Message-ID: <001f01c7eb83$003bca30$00b35e90$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcfrghCXlBUnQcrtTKK2mI+BYpsLegAAKzKQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> Hua - that said, I don't actually see why the commit you bisected to
> has anything to do with the issue being discussed. Can you double-check
> that it's literally that particular commit that breaks for you (you could
> try just reverting that commit).

I will double check that tomorrow. Thanks. :-) I'm happy I'll still be able
to test the latest kernels on my work desktop.

> 			Linus

