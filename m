Return-Path: <linux-kernel-owner+w=401wt.eu-S932838AbZGPRRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbZGPRRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932793AbZGPRRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:17:05 -0400
Received: from cobra.newdream.net ([66.33.216.30]:58540 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748AbZGPRRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:17:04 -0400
Date: Thu, 16 Jul 2009 10:17:04 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/20] ceph: debugging
In-Reply-To: <87d480x16p.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0907161014330.8026@cobra.newdream.net>
References: <1247693090-27796-1-git-send-email-sage@newdream.net>
 <1247693090-27796-4-git-send-email-sage@newdream.net>
 <1247693090-27796-5-git-send-email-sage@newdream.net>
 <1247693090-27796-6-git-send-email-sage@newdream.net>
 <1247693090-27796-7-git-send-email-sage@newdream.net>
 <1247693090-27796-8-git-send-email-sage@newdream.net>
 <1247693090-27796-9-git-send-email-sage@newdream.net>
 <1247693090-27796-10-git-send-email-sage@newdream.net>
 <1247693090-27796-11-git-send-email-sage@newdream.net>
 <1247693090-27796-12-git-send-email-sage@newdream.net>
 <1247693090-27796-13-git-send-email-sage@newdream.net>
 <1247693090-27796-14-git-send-email-sage@newdream.net>
 <1247693090-27796-15-git-send-email-sage@newdream.net>
 <1247693090-27796-16-git-send-email-sage@newdream.net>
 <1247693090-27796-17-git-send-email-sage@newdream.net>
 <1247693090-27796-18-git-send-email-sage@newdream.net>
 <1247693090-27796-19-git-send-email-sage@newdream.net> <87d480x16p.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Andi Kleen wrote:
> Sage Weil <sage@newdream.net> writes:
> 
> > Some debugging infrastructure, including the ability to adjust the
> > level of debug output on a per-file basis.
> 
> That is already provided by pr_debug()/DYNAMIC_PRINTK in newer kernels.
> You should switch to that.

Oh, that's much better.  Thanks!

sage
