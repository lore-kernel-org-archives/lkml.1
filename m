Return-Path: <linux-kernel-owner+w=401wt.eu-S1761765AbYDCHpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761765AbYDCHpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759168AbYDCHpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:45:46 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:22453 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729AbYDCHpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gMwhBp/LTdk5PyApoMqHcxTuztYOPgh5dkYecOKyDurUZKHNMwVYG7hsxb4B1t3deupewMobKRvFtmx50IRMNrbppkyZFcu3BGn8kMjTrce7KgsXG3olyIH16pmrg5vmQPQ8foY3tWPP3itMoeR2cxQqR3Y2/OZRICryd6zKato=
Message-ID: <84144f020804030045p44456894lfc006dcdeab6f67c@mail.gmail.com>
Date: Thu, 3 Apr 2008 10:45:44 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [rfc] SLQB: YASA
Cc: "Linux Memory Management List" <linux-mm@kvack.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080403072550.GC25932@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403072550.GC25932@wotan.suse.de>
X-Google-Sender-Auth: 2b49654bf29beed8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Thu, Apr 3, 2008 at 10:25 AM, Nick Piggin <npiggin@suse.de> wrote:
>  I'm not quite sure what to do with this. If anybody could test or comment,
>  I guess that would be a good start :)

Why is this not a patch set against SLUB?
