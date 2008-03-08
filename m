Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbYCHByn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbYCHByn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYCHBye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:54:34 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:46974 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbYCHBye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:54:34 -0500
Date: Sat, 8 Mar 2008 02:54:26 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: David Chinner <dgc@sgi.com>
cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
In-Reply-To: <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de>
Message-ID: <alpine.DEB.1.00.0803080251110.4325@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2008, Christian Kujau wrote:
> I have 7 processes in D state so far:

FWIW, it's 100% reproducible with 2.6.25-rc3 too...sigh :-\
So, the last working kernel for me is 2.6.24.1 - that's a lot of bisecting 
and I fear that compile errors will invalidate the bisecting results again 
or make it impossible at all....I'll try anyway....tomorrow...

C.
-- 
BOFH excuse #285:

Telecommunications is upgrading.
