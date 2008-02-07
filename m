Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYBGIMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYBGIMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYBGIMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:12:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329AbYBGIMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:12:33 -0500
Date: Thu, 7 Feb 2008 00:12:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: maxk@qualcomm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] CPU isolation extensions
Message-Id: <20080207001235.a9baac90.akpm@linux-foundation.org>
In-Reply-To: <20080207015954.92cd3878.pj@sgi.com>
References: <47AA9807.7090402@qualcomm.com>
	<20080206215805.17a0c919.akpm@linux-foundation.org>
	<20080207015954.92cd3878.pj@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 01:59:54 -0600 Paul Jackson <pj@sgi.com> wrote:

> but hard real time is
> not my expertise

Speaking of which..  there is the -rt tree.  Have those people had a look
at the feature, perhaps played with the code?
