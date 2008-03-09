Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbYCISsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbYCISsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 14:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYCISsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 14:48:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbYCISsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 14:48:37 -0400
Date: Sun, 9 Mar 2008 11:47:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <tomof@acm.org>
Cc: ink@jurassic.park.msu.ru, rct@frus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [regression]2.6.25-rc4: boot panic on alpha
Message-Id: <20080309114759.79365cdd.akpm@linux-foundation.org>
In-Reply-To: <20080309222953K.tomof@acm.org>
References: <20080308012440.39177DBA2@gherkin.frus.com>
	<20080309191950P.tomof@acm.org>
	<20080309132256.GA757@jurassic.park.msu.ru>
	<20080309222953K.tomof@acm.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008 22:29:54 +0900 FUJITA Tomonori <tomof@acm.org> wrote:

> On Sun, 9 Mar 2008 16:22:56 +0300
> Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:
> 
> > On Sun, Mar 09, 2008 at 07:20:20PM +0900, FUJITA Tomonori wrote:
> > > Ivan, can you resend the patch with a description and signed-off-by?
> > 
> > I was going to do that, but since Andrew has picked up that patch
> > I thought it wasn't necessary...
> 
> Maybe, but the -mm commit mail was not sent to linux-kernel or
> Linus. I just wanted to make sure that the patch will be applied to
> mainline shortly.

Yup, I have it in my next-batch-for-Linus.  Maybe tomorrow..
