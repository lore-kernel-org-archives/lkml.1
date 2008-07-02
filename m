Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYGBSPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYGBSPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 14:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYGBSOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 14:14:53 -0400
Received: from kanga.kvack.org ([66.96.29.28]:59277 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbYGBSOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:14:53 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2008 14:14:53 EDT
Date: Wed, 2 Jul 2008 13:59:31 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] aio: aio_complete() will never be called in interrupt context
Message-ID: <20080702175931.GK7018@kvack.org>
References: <200806260930.59836.knikanth@suse.de> <200807011359.57164.knikanth@suse.de> <486A8A92.6050200@oracle.com> <200807021030.43009.knikanth@suse.de> <486BAF01.1040601@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486BAF01.1040601@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 09:38:25AM -0700, Zach Brown wrote:
> Yeah, it's perhaps not the best that this is still hosted over on Ben's
> personal boxes.  I wonder if we should move to linux-aio@vger..

Just tell me where to point it to...

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
