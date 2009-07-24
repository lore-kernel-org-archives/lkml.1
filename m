Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZGXSZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZGXSZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 14:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZGXSZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 14:25:58 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55154 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbZGXSZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:25:57 -0400
Date: Fri, 24 Jul 2009 23:55:47 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
Message-ID: <20090724182547.GB29851@skywalker>
References: <200907240145.31935.rjw@sisk.pl> <2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 05:21:36PM -0700, Ray Lee wrote:
> On Thu, Jul 23, 2009 at 4:45 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> > A recent kernel change broke kdesu (from KDE 4.2) on my test boxes.  ISTR a
> > discussion about that, but I can't find it right now.  Any clues?
> 
> See the thread starting here: ("possible regression with pty.c commit")
>    http://lkml.org/lkml/2009/7/11/125

I am also facing a similar problem.

http://bugzilla.kernel.org/show_bug.cgi?id=13815

-aneesh
