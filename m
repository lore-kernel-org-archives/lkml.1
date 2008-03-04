Return-Path: <linux-kernel-owner+w=401wt.eu-S1764172AbYCDMJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764172AbYCDMJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYCDMJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:09:43 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:24803 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYCDMJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:09:43 -0500
Subject: Re: [PATCH] 2.6.25-rc3-git5 Build fails on s390x
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, apw@shadowen.org
In-Reply-To: <20080304113806.GA27293@linux.vnet.ibm.com>
References: <20080304113806.GA27293@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 04 Mar 2008 13:09:35 +0100
Message-Id: <1204632575.1278.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 17:08 +0530, Kamalesh Babulal wrote:
> The 2.6.25-rc3-git5 kernel build fails on s390x with
> 
> drivers/s390/char/defkeymap.c:155: error: missing terminating ' character
> drivers/s390/char/defkeymap.c:156: error: syntax error before ';' token
> make[2]: *** [drivers/s390/char/defkeymap.o] Error 1
> make[1]: *** [drivers/s390/char] Error 2
> make: *** [drivers/s390] Error 2
> 
> I have tested the patch for build failure only.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Added to the queue with a small change to the description.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


