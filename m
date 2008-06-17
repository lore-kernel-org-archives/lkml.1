Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYFQDts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYFQDts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 23:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYFQDtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 23:49:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:56611 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbYFQDtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 23:49:39 -0400
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1213673979.8129.156.camel@pasglop>
References: <200806162124.43005.bzolnier@gmail.com>
	 <1213673979.8129.156.camel@pasglop>
Content-Type: text/plain
Date: Tue, 17 Jun 2008 13:49:32 +1000
Message-Id: <1213674572.8129.159.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-17 at 13:39 +1000, Benjamin Herrenschmidt wrote:
> Your patches don't apply on today upstream, I'll try against
> linux-next or is there a git I can clone to test things ?

Ok, I'm lost. I have 3 different series of patches from you partially
overlapping with different amount of patches in them. I don't have
time to sort that out right now. Can you send me a single serie that
I can apply on top of either upstream or tonight linux-next which
should have your stuff removed hopefully ?

Ben.


