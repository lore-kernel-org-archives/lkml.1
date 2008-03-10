Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbYCJOfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbYCJOfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 10:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYCJOfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 10:35:33 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52779 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbYCJOfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 10:35:31 -0400
Date: Mon, 10 Mar 2008 23:34:51 +0900
To: ink@jurassic.park.msu.ru
Cc: tomof@acm.org, rct@frus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org
Subject: Re: [regression]2.6.25-rc4: boot panic on alpha
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <20080309153859.GB1391@jurassic.park.msu.ru>
References: <20080309132256.GA757@jurassic.park.msu.ru>
	<20080309222953K.tomof@acm.org>
	<20080309153859.GB1391@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080310230952D.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008 18:38:59 +0300
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:

> On Sun, Mar 09, 2008 at 10:29:54PM +0900, FUJITA Tomonori wrote:
> > Thanks! Of course, you can add my Acked-by.
> 
> BTW, I feel a bit sorry for not ACKing your patches in time - I wasn't able
> to test them then and I was perhaps too overcautious because of that...
> But they are really good.

No problem, thanks for finding my stupid typo quickly :)

The patchset was merged instantly so it was difficult to review it in
time.
