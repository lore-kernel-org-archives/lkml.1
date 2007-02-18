Return-Path: <linux-kernel-owner+w=401wt.eu-S1030331AbXBRGSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030331AbXBRGSR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 01:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030334AbXBRGSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 01:18:17 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:63148 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030331AbXBRGSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 01:18:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ujjoGQtaPKonVZdY6Ct41snrN4dCmKRkwxttoM/ASGXOKGts0VMjPKd+78moyoXmmvipRMiohwHnD07bYefaG0aPotHLXTZfS7U/KZxqZgO44+0QUM2BSKBNzzNW8IK5aTmYezKzw7VWFgnnagDXDbyI+ih/VCTwFv1w+LEP0zY=
Message-ID: <21d7e9970702172218k4d86d054w589768a0744315a4@mail.gmail.com>
Date: Sun, 18 Feb 2007 17:18:14 +1100
From: "Dave Airlie" <airlied@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.20-mm2
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - git-drm.patch is still in disgrace
>

Okay I think I've fixed it up, some of the locking code from the DRM
git devel repo was completely integrated..

Dave.
