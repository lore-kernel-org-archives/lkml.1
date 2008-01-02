Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYABWlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYABWlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 17:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYABWls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 17:41:48 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:52822 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYABWlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 17:41:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Li7piIRiWkh301/AAWlJT/dblSE6EkPlSkItzH/M0JAuUIh57l/tdon1suJK1xO75IVPuwyn3KthTSebi1ZbwkXD9QYY3LPZMrtC+5oPZwASHhkfq6CmYA3kyl7BJsc60EozKnb0aChVMIWyxmaFILjwHXhlyqO5WjrCCHHGDYA=
Message-ID: <4d8e3fd30801021441h51f180des465f94ed24b107c2@mail.gmail.com>
Date: Thu, 3 Jan 2008 02:11:44 +0330
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: New branch for +1 kernel Was:Re: [PATCH] Use __u64 in aligned_u64's definition
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/3/08, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > 2.6.25 actually. You don't take patches this early, do you?
>
> Yeah, no, I don't take patches early. I've considered setting up another
> branch for early patches, but decided that I'm (a) lazy and (b) better off
> encouraging people in the late -rc timeframe to just concentrate on the
> -rc's, not the next version.


This is something i was thinking to suggest.
Kernel is made of a lot of different "areas" and the regression list
is a great tool for monitoring every single area so why not opening a
new branch and accepting patches only for areas which are not in the
current regression list.?
Sounds like a good way to be more strict about regressions and
incentive people to solve regressions quicker.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
