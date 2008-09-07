Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbYIGRwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbYIGRwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 13:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYIGRwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 13:52:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:37281 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbYIGRwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 13:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IlvUwSignyMPxn0gHOzfsLGmdA0BL7FGdGCHJoFwojbeNJB9zyDNu19vts9s6jg6zm
         zAwCea5FQIW+nkEiq5Si9+o7fmP05nu4Fj5yc5y/7cxys88pIqE55cm/LgEH9wnD1E+y
         cT96QrFsvxbq4B/mgOj5FmIfeyh6QUoe9YWfo=
Message-ID: <41b516cb0809071052t1aea47b3hd7dc40d3bb1cfce3@mail.gmail.com>
Date: Sun, 7 Sep 2008 10:52:04 -0700
From: "Chris Leech" <chris.leech@gmail.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: [PATCH 1/3] 24-bit types: typedef and macros for accessing 3-byte arrays as integers
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       "Harvey Harrison" <harvey.harrison@gmail.com>
In-Reply-To: <48C40DB4.5050007@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080905165732.16689.50256.stgit@localhost.localdomain>
	 <48C3A0A9.3000206@panasas.com>
	 <41b516cb0809070856v2000b93bm5305236e4a98b81a@mail.gmail.com>
	 <48C40DB4.5050007@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2008 at 10:21 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> I wanted to see what you're saying and tried this test code below:
>
> <test.c>
>
> I get the exact same assembly.
>
> What am I doing wrong ?

Interesting.  My earlier comparisons were done in the kernel and
comparing the resulting libicssi.o and iscsi_tcp.o.  Let me look into
this more.

Chris
