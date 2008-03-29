Return-Path: <linux-kernel-owner+w=401wt.eu-S1761943AbYC2DPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761943AbYC2DPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761756AbYC2DPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:15:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:23230 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760710AbYC2DPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OUg1Qyo/L36IXAwyVi0hRM9yh0EZxpk+/FIOnprvvFYEq6Tg7tJ01OirQCpGvdKqg9GChnG7bc2KEGB9uPel9HH62NKREtCxPpGjoe09x5yDkoiXnuRLMsS6eBdyiaaxeaSUXge1oGDQcFFdH/4Cv7tC8dRxR2UtOPSqpzXX/bU=
Subject: Re: [PATCH] jbd/jbd2 NULL noise
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <E1JfRPa-0002U9-J5@ZenIV.linux.org.uk>
References: <E1JfRPa-0002U9-J5@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 20:15:26 -0700
Message-Id: <1206760526.6543.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-29 at 03:07 +0000, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/jbd/journal.c  |    4 ++--
>  fs/jbd/revoke.c   |    4 ++--
>  fs/jbd2/journal.c |   12 ++++++------
>  fs/jbd2/revoke.c  |    4 ++--
>  4 files changed, 12 insertions(+), 12 deletions(-)
> 

I had just about all of fs/ done for this sitting in mm.

Harvey

