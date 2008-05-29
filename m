Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbYE2PAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbYE2PAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbYE2PAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:00:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbYE2PAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:00:13 -0400
Date: Thu, 29 May 2008 10:43:40 -0400
From: Rik van Riel <riel@redhat.com>
To: carsteno@de.ibm.com
Cc: cotte@de.ibm.com, linux-kernel@vger.kernel.org,
       Christian Borntraeger <CBORNTRA@de.ibm.com>
Subject: Re: [PATCH -mm 00/16] VM pageout scalability improvements (V8)
Message-ID: <20080529104340.6af3093f@bree.surriel.com>
In-Reply-To: <483EA5EF.70906@de.ibm.com>
References: <20080523195506.084894989@redhat.com>
	<483EA5EF.70906@de.ibm.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 14:47:43 +0200
Carsten Otte <cotte@de.ibm.com> wrote:

> I'd like to try your patchset to see how that behave in this scenario. 
> Do you have a version that applies against current git, 2.6.26-rc3 or 
> similar?

I have a slightly older version of this patch set against
2.6.25 - it may apply to -rc3.  I mostly stick to the -mm
kernels though, since that is my merge target.

-- 
All rights reversed.
