Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbYAXRH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYAXRH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760518AbYAXRHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:07:01 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:32874 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760501AbYAXRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:06:59 -0500
Message-ID: <4798C5AF.10603@davidnewall.com>
Date: Fri, 25 Jan 2008 03:36:55 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Karl Kiniger <karl.kiniger@med.ge.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
References: <20080120031153.GB6275@one.firstfloor.org> <p73k5m1lygb.fsf@crumb.suse.de> <20080123141222.GA29243@wszip-kinigka.euro.med.ge.com> <200801231524.35294.andi@firstfloor.org>
In-Reply-To: <200801231524.35294.andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> I stand by my earlier point that it doesn't make sense to have all
> Linux kernels always execute these strcmps.
>   

Why?  It's a trivial expense.  Alternatively, (rhetorically), why not
also remove AOUT and COFF support?  Same argument.
