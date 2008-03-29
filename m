Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYC2Srb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYC2Srb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 14:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYC2SrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 14:47:24 -0400
Received: from hs-out-0708.google.com ([64.233.178.244]:26784 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbYC2SrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 14:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sEO2FG4Sd0FvXJ2Ib0vwmSdSq5Lxmb4plwuv3iS7fQC6MBlFKoWIRQFrKo9QckdlKNHfYIAsbKmK8Z+bbBrvMC9C2zj112ZKJNN6uFhQa576TVWEyoRDigChntN8QrN34QO1/LsvliT0Vx7X2ZfJK5oIi+jA9q6lWG3fcbOLiig=
Subject: Re: [PATCH] NULL noise: frv cmpxchg()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <E1JfRQY-0002dr-JG@ZenIV.linux.org.uk>
References: <E1JfRQY-0002dr-JG@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Sat, 29 Mar 2008 11:47:27 -0700
Message-Id: <1206816447.6543.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-29 at 03:08 +0000, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  include/asm-frv/system.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 

Not in -mm, please apply.

Harvey

