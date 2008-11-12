Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbYKLAqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbYKLAqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbYKLAjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:39:54 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:56315 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbYKLAjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:39:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=T/GuwtwYGG0pRewNsSzWVaWrlPqrCyYGOjcYe5Wu4VxfkXxc6mPwq+y11UUlU+eR/o
         DsydTU3H20tMnWoHuOBExDnGuFcagmS+DgEAjvd40zm+qZxeOi1UwNISy1GHJeNYXPO7
         KnuQOI7/4vVOEu2mf4bVGBOXURresgw6hCK6Y=
Message-ID: <9f8af95f0811111639v38d48316t1864c93fc16334a8@mail.gmail.com>
Date: Tue, 11 Nov 2008 19:39:50 -0500
From: jT <toyj@union.edu>
To: LKML <linux-kernel@vger.kernel.org>
Subject: mmotm stamp-2008-11-10-14-54
Cc: "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 053cc9e8648d6645
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew/All,

   When this patch is removed : align-avoid-evaluating-its-argument-twice.patch

these silly errors go away :


include/linux/kexec.h:201: error: braced-group within expression
allowed only inside a function
include/linux/kexec.h:201: error: braced-group within expression
allowed only inside a function

just fixes the ALIGN_MASK

-- 
/jT
http://git.zen-sources.org/?p=kernel/zenmm.git;a=summary
