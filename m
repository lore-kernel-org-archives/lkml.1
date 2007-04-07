Return-Path: <linux-kernel-owner+w=401wt.eu-S966111AbXDGQ5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966111AbXDGQ5g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966126AbXDGQ5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:57:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:51798 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966111AbXDGQ5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mQEcPvxNBk9hilcBBRWFP5O5MzddlkRjxOLxHnDUqldxuLL145iTkIPtBY1/Ugr8HwnWAK+CBjc5gpJ/HV/wS6fSsWe3a/zEbTWA8h5pPKq7RFATtmjzmPULc2edDnvO43RYz6Up6XOu2HCApAJIkSZSsvbuMyaiitrSjbsQexE=
Message-ID: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
Date: Sat, 7 Apr 2007 09:57:32 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: If not readdir() then what?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In their closed chambers (well, workshops,
http://lwn.net/Articles/226351/), the filesystem developers complain
about readdir.  I fully appreciate the difficulties.  But what I fail
to see so far is any proposal for an alternative interface.

The phase to get new functionality included in the next revision of
POSIX is over.  But that does not mean we should not try to get some
sensible new implementation in place.  There is, for example, the
"High End Computing Extensions Working Group" (the guys who showed up
here with their statlite and readdirplus proposals).  This is an
official working group at the OpenGroup which can produce a document
which can be the basis of inclusion in the next revision and become a
OpenGroup specification earlier than that.

So, if anybody has a proposal for better interfaces let's hear them.
"Now" is a very good time to start working on this.
