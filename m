Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYKTJ1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYKTJ1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbYKTJ1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:27:16 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51841 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbYKTJ1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:27:11 -0500
Subject: Re: [PATCH] Add might_sleep_if() for slub
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <87abbv29b4.fsf@devron.myhome.or.jp>
References: <87abbv29b4.fsf@devron.myhome.or.jp>
Date: Thu, 20 Nov 2008 11:28:37 +0200
Message-Id: <1227173318.9459.1.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 21:23 +0900, OGAWA Hirofumi wrote:
> I don't know it is intention, or not. However, current SLUB not seems to
> warn about might_sleep_if(gfpflags & __GFP_WAIT);
> 
> If it's not intention, please apply.

Applied, thanks!

