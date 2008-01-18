Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYARJ0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYARJ0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYARJ0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:26:22 -0500
Received: from smtp-out.google.com ([216.239.33.17]:46934 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYARJ0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:26:21 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ddEvYnJbwnGo457p3SdKizrBRnXQfjEiqBmKYNrR7B7s+Xq9WLBEJ3Fx3M1CYtzop
	EQDTndNzfxQABVrHSdc3w==
Message-ID: <532480950801180126q3088e47dx1ac07dbd8390ca71@mail.gmail.com>
Date: Fri, 18 Jan 2008 01:26:07 -0800
From: "Michael Rubin" <mrubin@google.com>
To: "David Chinner" <dgc@sgi.com>
Subject: Re: [patch] Converting writeback linked lists to a tree based data structure
Cc: "Fengguang Wu" <wfg@mail.ustc.edu.cn>, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080118085407.GV155259@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080115080921.70E3810653@localhost> <400562938.07583@ustc.edu.cn>
	 <532480950801171307q4b540ewa3acb6bfbea5dbc8@mail.gmail.com>
	 <20080118050107.GS155259@sgi.com>
	 <532480950801172138x44e06780w2b15464845b626fc@mail.gmail.com>
	 <20080118085407.GV155259@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 12:54 AM, David Chinner <dgc@sgi.com> wrote:
> At this point, I'd say it is best to leave it to the filesystem and
> the elevator to do their jobs properly.

Amen.

mrubin
