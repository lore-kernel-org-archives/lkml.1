Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbZHFREc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbZHFREc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 13:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbZHFREb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 13:04:31 -0400
Received: from cobra.newdream.net ([66.33.216.30]:46280 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbZHFREb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 13:04:31 -0400
Date: Thu, 6 Aug 2009 10:04:31 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] ceph: ioctls
In-Reply-To: <87prb9hrux.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0908061004090.23973@cobra.newdream.net>
References: <1249511439-31088-1-git-send-email-sage@newdream.net>
 <1249511439-31088-3-git-send-email-sage@newdream.net>
 <1249511439-31088-4-git-send-email-sage@newdream.net>
 <1249511439-31088-5-git-send-email-sage@newdream.net>
 <1249511439-31088-6-git-send-email-sage@newdream.net>
 <1249511439-31088-7-git-send-email-sage@newdream.net>
 <1249511439-31088-8-git-send-email-sage@newdream.net>
 <1249511439-31088-9-git-send-email-sage@newdream.net>
 <1249511439-31088-10-git-send-email-sage@newdream.net>
 <1249511439-31088-11-git-send-email-sage@newdream.net>
 <1249511439-31088-12-git-send-email-sage@newdream.net>
 <1249511439-31088-13-git-send-email-sage@newdream.net>
 <1249511439-31088-14-git-send-email-sage@newdream.net>
 <1249511439-31088-15-git-send-email-sage@newdream.net>
 <1249511439-31088-16-git-send-email-sage@newdream.net>
 <1249511439-31088-17-git-send-email-sage@newdream.net>
 <1249511439-31088-18-git-send-email-sage@newdream.net> <87prb9hrux.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Aug 2009, Andi Kleen wrote:
> Sage Weil <sage@newdream.net> writes:
> 
> > A few Ceph ioctls for getting and setting file layout (striping)
> > parameters.
> 
> FWIW I reviewed this file and found nothing bad in it.

Thanks :)
sage
