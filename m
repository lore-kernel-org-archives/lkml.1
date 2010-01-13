Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234Ab0AMUTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0AMUTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 15:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016Ab0AMUTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 15:19:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59998 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab0AMUTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 15:19:36 -0500
Date: Wed, 13 Jan 2010 21:19:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v4] tcp: harmonize tcp_vx_rcv header length assumptions
Message-ID: <20100113201931.GD24818@basil.fritz.box>
References: <4B49D001.4000302@gmail.com> <4B4DA4F4.6060007@gmail.com> <20100113115617.GA24818@basil.fritz.box> <4B4DE887.6030602@gmail.com> <20100113155323.GB24818@basil.fritz.box> <4B4E23E0.4000007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4E23E0.4000007@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The short answer is yes, it saves a bit more than I'd expected!

Thanks for checking.

-Andi

