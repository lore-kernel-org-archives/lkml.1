Return-Path: <linux-kernel-owner+w=401wt.eu-S1765902AbZAPJmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765902AbZAPJmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759628AbZAPJmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:42:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:58029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757908AbZAPJmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:42:05 -0500
Message-ID: <4970564F.8030004@kernel.org>
Date: Fri, 16 Jan 2009 18:41:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, roel kluin <roel.kluin@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
       ebiederm@xmission.com, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com> <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu> <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com> <496F0F5E.3080404@kernel.org> <20090115113230.GH22850@elte.hu> <496F1FA6.6050204@kernel.org> <20090115122222.GI22850@elte.hu> <Pine.LNX.4.64.0901151430470.28153@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0901151430470.28153@quilx.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 16 Jan 2009 09:41:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 15 Jan 2009, Ingo Molnar wrote:
> 
>>  - i standardized the commit logs to the usual x86 style and added
>>    Original-From: Mike Travis tags to those patches that were derived from
>>    Mike's patches.
> 
> Most of that is based on earlier patches by me.

Sorry, I didn't know that.  Ingo, please feel free to re-base the tree
with updated credits.

Thanks.

-- 
tejun
