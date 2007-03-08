Return-Path: <linux-kernel-owner+w=401wt.eu-S933340AbXCHVEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbXCHVEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933334AbXCHVEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:04:50 -0500
Received: from mail19.syd.optusnet.com.au ([211.29.132.200]:47082 "EHLO
	mail19.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933332AbXCHVEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:04:49 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc3-mm2
Date: Fri, 9 Mar 2007 08:04:38 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070307201915.4d579113.akpm@linux-foundation.org> <200703090152.49253.kernel@kolivas.org>
In-Reply-To: <200703090152.49253.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703090804.39067.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 01:52, Con Kolivas wrote:
> Summary from what I've been able to find:
> x86_32: ok
> x86_64: ok
> x86_64 fat config: scheduler code oops brought on by accessing /proc
> IA64 ok: ok
> Alpha: bitmap error, runs ok

PA-Risc: ok

Now what is it about ppc and Alpha that make it hit the bitmap error on 
startup...

-- 
-ck
