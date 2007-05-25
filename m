Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbXEYAjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbXEYAjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbXEYAjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:39:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:21285 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXEYAjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:39:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mRvIaVrzZNybNv/M32L68GtpI3HO3H8hHDUvsiCwmExVl2WVC5nBRMhNQzrxROfCHVNMDpZQ2MCoQ+ZBl+/h4Ik37SUFQq9QTOVYFKayE1LAn90chzoGKRnmmn0xxm4mdje6pV+KZkO3ToP9SIbnZ8QDqPzANt7DJ4D1UiSpJEg=
Message-ID: <a8e1da0705241739sc9f22b0x6e0ba225bb4fc5d9@mail.gmail.com>
Date: Fri, 25 May 2007 00:39:42 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: 2.6.22-rc2-mm1 SLUB oops
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705240936360.27844@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705240111l790ee29emdd872cf6c56a5e37@mail.gmail.com>
	 <Pine.LNX.4.64.0705240936360.27844@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Reboot with slub_debug as a kernel parameter please.

Yes, I will enable slub_debug as boot parameter, but it doesn't occur
definitely.

I will report the info if it arrive again ASAP.

Regards
dave
