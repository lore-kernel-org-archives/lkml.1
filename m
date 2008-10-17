Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbYJQJFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbYJQJFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 05:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752148AbYJQJFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 05:05:33 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:63820 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbYJQJFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 05:05:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dANbRGq5iponOcsdayo1drly2eg9GCrzBBuSqDXUfFPv94yksIN0CUvPL3ubuPT0f6
         D8bTjjSWQ4GbHLRXnMLipWXZGs/FIvoo9My+kPKPhOH90/UWnptmxuzVRmAM+TLN1Xo/
         5Wq7MEc68UOL4j1/XWFbjtyzKO2i4eF/UN8gA=
Message-ID: <df9815e70810170205s4f25914dy7e24a081447d285d@mail.gmail.com>
Date: Fri, 17 Oct 2008 17:05:28 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [RFC] Kernel version numbering scheme change
Cc: "Theodore Tso" <tytso@mit.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <a8e1da0810161853m3bbd8c1hf7c2ed5adf4cc4d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081016002509.GA25868@kroah.com>
	 <20081016142619.GA3756@tatooine.rebelbase.local>
	 <20081016153512.GE12962@mit.edu>
	 <a8e1da0810161853m3bbd8c1hf7c2ed5adf4cc4d6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 9:53 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
>
> Additionally, we can add some range to x.y.z
>
> such as:
>
> x: 1-9
> y: 1-9
> z: 1-30
>
> so we can jumo to 2.7.1 after 2.6.30
>

Then people will think 2.7.x is a development version like 2.5.x ...
