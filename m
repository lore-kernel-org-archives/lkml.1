Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbZABIuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbZABIuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 03:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbZABIub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 03:50:31 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:57323 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbZABIua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 03:50:30 -0500
Subject: Re: [PATCH] asm-s390/posix_types.h: drop __USE_ALL usage
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux390@de.ibm.com, linux-s390@vger.kernel.org
In-Reply-To: <1230882782-9977-1-git-send-email-vapier@gentoo.org>
References: <1230882782-9977-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 02 Jan 2009 09:50:27 +0100
Message-Id: <1230886227.5474.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Fri, 2009-01-02 at 02:53 -0500, Mike Frysinger wrote:
> Bring s390 in line with all the other ports.  Not sure how s390 missed
> this change as all the other arches were being updated ...

Should I carry the patch via git390?

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


