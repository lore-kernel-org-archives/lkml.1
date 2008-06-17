Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbYFQJjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbYFQJjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 05:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYFQJje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 05:39:34 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:18299 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbYFQJjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 05:39:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=GnwQdnS4ufCuYBNbOcuaKdjG9zb8moFXarVo+TyCu7DxvWZKKRz8DuFTI2xleW2uUc
         nqDrWPJdgTfilGbBYqY5ej3xosMp7fOg13Pzg8a/bkTLbulhEbQDfyHdJ2RTGlbmHw+8
         ft+rLUVU4sJ/GtBwNltdZCnnNNwyKABnyAs4U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
Date: Tue, 17 Jun 2008 11:41:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200806162124.43005.bzolnier@gmail.com> <1213673979.8129.156.camel@pasglop> <1213674572.8129.159.camel@pasglop>
In-Reply-To: <1213674572.8129.159.camel@pasglop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806171141.08865.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2008, Benjamin Herrenschmidt wrote:
> On Tue, 2008-06-17 at 13:39 +1000, Benjamin Herrenschmidt wrote:
> > Your patches don't apply on today upstream, I'll try against
> > linux-next or is there a git I can clone to test things ?
> 
> Ok, I'm lost. I have 3 different series of patches from you partially
> overlapping with different amount of patches in them. I don't have
> time to sort that out right now. Can you send me a single serie that
> I can apply on top of either upstream or tonight linux-next which
> should have your stuff removed hopefully ?

This patch series (from yesterday, the rest of can be ignored) should
apply fine to the next revision of linux-next (later than -next-20080616,
it is not out yet), if you prefer upstream patches I can look into it
tonight.

Thanks,
Bart
