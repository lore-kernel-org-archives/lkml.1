Return-Path: <linux-kernel-owner+w=401wt.eu-S1761950AbXEWKBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761950AbXEWKBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758245AbXEWKBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:01:11 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:51730 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbXEWKBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:01:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mxmaxtF4UJiFhj5kbt/hhjxhy/NRrrWl+l1aPhfBY12VBrpEBFl3CL7v4D+bmNdDmMIDON2bbFmQ6vTIImtCXbbCbeVrSd4Rxnhr/rvm6MN3+KBUrjXeznVmY4MoRLL/+KfQnaymMystMDi2KjuIC9vQe+VVwqzTQQW+sG5MeVM=
Message-ID: <d9b9d95f0705230301qa78344chdefef5a3513b3e70@mail.gmail.com>
Date: Wed, 23 May 2007 11:01:07 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Subject: Re: [PATCH] joydev.c automatic re-calibration
Cc: linux-kernel@vger.kernel.org,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0705231130540.27422@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705221733l46de4262qd9c3f5047c53667@mail.gmail.com>
	 <Pine.LNX.4.64.0705231130540.27422@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/07, Jiri Kosina <jikos@jikos.cz> wrote:
> (Adding Dmitry to CC so that he doesn't miss it.
>
> Also, if you'd like to get your patch merged, you should add proper
> Signed-off-by line.

Hi Jiri,

Sorry, it's my first kernel patch, how do I add Signed-off-by line?

I did with:

$ diff -u original changed

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
