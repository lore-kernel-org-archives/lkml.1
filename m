Return-Path: <linux-kernel-owner+w=401wt.eu-S933109AbZFLVuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbZFLVuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758925AbZFLVtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:49:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38855 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbZFLVtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:49:53 -0400
Message-ID: <4A32CD79.5040803@redhat.com>
Date: Sat, 13 Jun 2009 00:49:45 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: aarcange@redhat.com, akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       chrisw@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 0/4] RFC - ksm api change into madvise
References: <1242261048-4487-1-git-send-email-ieidus@redhat.com> <Pine.LNX.4.64.0906081555360.22943@sister.anvils> <4A2D47C1.5020302@redhat.com> <Pine.LNX.4.64.0906081902520.9518@sister.anvils> <4A2D7036.1010800@redhat.com> <20090609074848.5357839a@woof.tlv.redhat.com> <Pine.LNX.4.64.0906091807300.20120@sister.anvils> <Pine.LNX.4.64.0906092013580.31606@sister.anvils> <20090610092855.43be2405@woof.tlv.redhat.com> <Pine.LNX.4.64.0906111700390.18609@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0906111700390.18609@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
>
> Okay.  We do have a macro to annotate such pacifying initializations,
> but I've not used it before, and forget what it is or where to look
> for an example, I don't see it in kernel.h or compiler.h.  Maybe
> Andrew will chime in and remind us.
>
> Hugh
>   
I have looked on compiler.h - this file have something that deal with 
warnings, but didnt find anything that is good for our case....

Anyone know where is this thing is found?

