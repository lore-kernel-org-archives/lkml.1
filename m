Return-Path: <linux-kernel-owner+w=401wt.eu-S1763970AbYCDHgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763970AbYCDHgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 02:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYCDHgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 02:36:33 -0500
Received: from el-out-1112.google.com ([209.85.162.183]:61261 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYCDHgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 02:36:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=aOHb6Udgurld3p7smJzJLQYNVWY6swHGmS+qvwi0bVVeB6cbkvgeSGJsI8RTg+GvinzA9JN8FnVIkdfRS86L3jasOTC0b8Fn3vpaOh5MuG5PsK2TeO5TQeFXqAD1vqA8dUNu17Bg/00E8UXOUQboE1mldi2fdTVfmCUPfOdXJfw=
Message-ID: <84144f020803032336o6620642chaa5c25a0b7e5fa48@mail.gmail.com>
Date: Tue, 4 Mar 2008 09:36:28 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <200803030316.07165.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803030316.07165.rjw@sisk.pl>
X-Google-Sender-Auth: 1a5d9a181c3edf18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/3/3 Rafael J. Wysocki <rjw@sisk.pl>:
>  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10015
>  Subject         : [BUG] Linux 2.6.25-rc2 - Kernel Ooops while running dbench
>  Submitter       : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>  Date            : 2008-02-16 06:44
>  References      : http://lkml.org/lkml/2008/2/16/4

This is confirmed to be fixed (see comments in the bugzilla issue).
