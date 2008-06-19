Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbYFSKrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbYFSKrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 06:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbYFSKrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 06:47:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:50947 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbYFSKrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 06:47:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=M+HqlKRh8aq2AnV5W2leRo5uk4C4Eb6HS8Ceom3bHeinaYglvg/+IVLT2odKkYhvfa
         4ybgRf94GHBhqgr9nD59lPBwY/LU9WbKZofyaQy17PRGfcV/y6uPcT4OEw23iDGT1SFc
         bhwgbPb3PttjZAAymcTrribIim/CMcF/GprAc=
Message-ID: <84144f020806190346t6c27fa02w77de08a14bd5cb89@mail.gmail.com>
Date: Thu, 19 Jun 2008 13:46:57 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH] restore export of handle_mm_fault for Mac on Linux
Cc: "Gaudenz Steinlin" <gaudenz@debian.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       486798@bugs.debian.org, josejx@gentoo.org, "Greg KH" <greg@kroah.com>
In-Reply-To: <20080619103837.GA16331@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080618101402.GF15718@soziologie.ch>
	 <20080618181856.3474859d@lxorguk.ukuu.org.uk>
	 <20080619095805.GA28907@soziologie.ch>
	 <20080619103837.GA16331@infradead.org>
X-Google-Sender-Auth: 1e03756ae323564c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 11:58:05AM +0200, Gaudenz Steinlin wrote:
>> There is an effort underway to bring the MOL kernel modules into
>> a mergeable form. But it's not there yet. Joseph Jezak, the MOl main
>> developer nowdays is working on it. So MOL no longer want's to hide out
>> of tree. It just needs some more time.

On Thu, Jun 19, 2008 at 1:38 PM, Christoph Hellwig <hch@infradead.org> wrote:
> It would be useful if you could send some status-updates to lkml and
> the kvm list.

And why not submit MOL to the new linux-staging tree?
