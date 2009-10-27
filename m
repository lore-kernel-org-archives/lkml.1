Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZJ0P5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZJ0P5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 11:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbZJ0P5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 11:57:39 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:10147 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbZJ0P5j convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com;2:1>);
	Tue, 27 Oct 2009 11:57:39 -0400
Message-Id: <4AE6E0350200005A00057650@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 27 Oct 2009 09:57:41 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: Zillions of warnings in -next
References: <20091027152530.75ca60e4@lxorguk.ukuu.org.uk>
In-Reply-To: <20091027152530.75ca60e4@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10/27/2009 at 11:25 AM, in message
<20091027152530.75ca60e4@lxorguk.ukuu.org.uk>, Alan Cox
<alan@lxorguk.ukuu.org.uk> wrote: 
> I was thinking "what a lot of new warnings". Then I dug a little deeper
> and it seems that someone never bothered to try and build
> drivers/net/vbus-enet.c on a 32bit system.
> 
> So would you mind fixing the 27 new warnings introduced ?
> 
> Alan

Im on it.

Thanks Alan,
-Greg


