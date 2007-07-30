Return-Path: <linux-kernel-owner+w=401wt.eu-S967670AbXG3TvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967670AbXG3TvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967677AbXG3Tuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:50:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:41925 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966544AbXG3Tut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Bs9+eRqqeuI1HQNepDzzt2O8kH4A60bSd9bggErsOUJLVydxrdFgESeYxUnkAHbKoQtj/sFBNCHggx15TQ2YYja52shGNQWECZOpNe8kbzU8F7FOqtE+U386S7ucWUDY3yp+IV45ZY9gpMPgJk4hvh56KjkTEoZ/PSc58+lpaFU=
Message-ID: <dda83e780707301250m4c2b759ewd817dd35e08db44c@mail.gmail.com>
Date: Mon, 30 Jul 2007 12:50:20 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/3] 2.6.23-rc1: known regressions v3
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <46AE12EE.1070501@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46AE12EE.1070501@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Subject         : 2.6.23-rc1 regression: mm: fix fault vs invalidate race for linear mappings
> References      : http://lkml.org/lkml/2007/7/24/301
> Last known good : ?
> Submitter       : Bret Towe <magnade@gmail.com>
> Caused-By       : Nick Piggin <npiggin@suse.de>
>                   commit d00806b183152af6d24f46f0c33f14162ca1262a
> Handled-By      : ?
> Status          : unknown

fix has been commited
its in -git as a51b34593f691a0837d752a1394dcee19483c607
