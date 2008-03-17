Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbYCQIod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbYCQIod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYCQIoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:44:24 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:25520 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbYCQIoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:44:22 -0400
Subject: Re: [patch 2/2] zcrypt: add support for large random numbers
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, Ralph Wuerthner <rwuerthn@de.ibm.com>
In-Reply-To: <20080314091402.fa409ac7.randy.dunlap@oracle.com>
References: <20080314092523.147382820@de.ibm.com>
	 <20080314093046.914555041@de.ibm.com>
	 <20080314091402.fa409ac7.randy.dunlap@oracle.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 17 Mar 2008 10:44:10 +0100
Message-Id: <1205747051.16137.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-14 at 09:14 -0700, Randy Dunlap wrote:
> Linux kernel uses "/**" to indicate the beginning of kernel-doc
> notation, so when the comment block is not kernel-doc, please don't
> use that /** to begin the comment block.
> (multiple occurrences of this)

True. This is done consistently wrong in the zcrypt driver. I would
prefer to do a separate kernel-doc cleanup patch and leave this patch as
it is. Ok ?

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


