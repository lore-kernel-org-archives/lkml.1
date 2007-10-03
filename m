Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbXJCMiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbXJCMiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbXJCMhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:37:52 -0400
Received: from namei.org ([69.55.235.186]:47618 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755570AbXJCMhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:37:51 -0400
Date: Wed, 3 Oct 2007 05:37:34 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
cc: penguin-kernel@I-love.SAKURA.ne.jp, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
In-Reply-To: <20071003.204356.05853536.yoshfuji@linux-ipv6.org>
Message-ID: <Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
References: <200710022144.BFF09817.VFFOOJLSFHtQMO@I-love.SAKURA.ne.jp>
 <Xine.LNX.4.64.0710020557170.21841@us.intercode.com.au>
 <200710032024.DJF78662.FHOLtMSFOOFJVQ@I-love.SAKURA.ne.jp>
 <20071003.204356.05853536.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="927316971-675843848-1191415054=:6431"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--927316971-675843848-1191415054=:6431
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 3 Oct 2007, YOSHIFUJI Hideaki / µÈÆ£±ÑÌÀ wrote:

> In article <200710032024.DJF78662.FHOLtMSFOOFJVQ@I-love.SAKURA.ne.jp> (at Wed, 3 Oct 2007 20:24:52 +0900), Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> says:
> 
> > It seems that standard kernel list API does not have singly-linked list manipulation.
> > I'm considering the following list manipulation API.
> 
> Tstsuo, please name it "slist", which is well-known.

I'm pretty sure that the singly linked list idea has been rejected a few 
times.  Just use the existing API.

-- 
James Morris
<jmorris@namei.org>
--927316971-675843848-1191415054=:6431--
