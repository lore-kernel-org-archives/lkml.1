Return-Path: <linux-kernel-owner+w=401wt.eu-S933995AbZAOVC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995AbZAOVC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933078AbZAOUcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:32:19 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:40583 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004AbZAOUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:32:17 -0500
Date: Thu, 15 Jan 2009 14:31:31 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Ingo Molnar <mingo@elte.hu>
cc: Tejun Heo <tj@kernel.org>, roel kluin <roel.kluin@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
       ebiederm@xmission.com, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
In-Reply-To: <20090115122222.GI22850@elte.hu>
Message-ID: <Pine.LNX.4.64.0901151430470.28153@quilx.com>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
 <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com>
 <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com>
 <20090114093834.GA19799@elte.hu> <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com>
 <496F0F5E.3080404@kernel.org> <20090115113230.GH22850@elte.hu>
 <496F1FA6.6050204@kernel.org> <20090115122222.GI22850@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Ingo Molnar wrote:

>  - i standardized the commit logs to the usual x86 style and added
>    Original-From: Mike Travis tags to those patches that were derived from
>    Mike's patches.

Most of that is based on earlier patches by me.
