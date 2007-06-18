Return-Path: <linux-kernel-owner+w=401wt.eu-S932645AbXFRUnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbXFRUnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764337AbXFRUnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:43:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:26211 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764053AbXFRUnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:43:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qv0g592fScN5OENPAGVPNpkUliTiX+uT1XHk7ZuCCow7c0slAF7nJRsCsOtqH9mPSmYR4j29EwLuNzkCEBxCo7tcn35AiPdGSWDaM4KnPDVDISx2p4Z5lViPlUEjuT5cAXQHBVI++S55TtYFFoAQ/oBh8RayWzEafwP+nbznLq4=
Message-ID: <6bffcb0e0706181343x1128bbf2p291f404778143777@mail.gmail.com>
Date: Mon, 18 Jun 2007 22:43:14 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [patch 00/26] Current slab allocator / SLUB patch queue
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       suresh.b.siddha@intel.com
In-Reply-To: <Pine.LNX.4.64.0706181217350.8899@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070618095838.238615343@sgi.com>
	 <46767346.2040108@googlemail.com>
	 <Pine.LNX.4.64.0706180936280.4751@schroedinger.engr.sgi.com>
	 <6bffcb0e0706181038j107e2357o89c525261cf671a@mail.gmail.com>
	 <Pine.LNX.4.64.0706181102280.6596@schroedinger.engr.sgi.com>
	 <6bffcb0e0706181158l739864e0t6fb5bc564444f23c@mail.gmail.com>
	 <Pine.LNX.4.64.0706181159430.1896@schroedinger.engr.sgi.com>
	 <6bffcb0e0706181209p49f4ae86xce5418b7c9b3edbb@mail.gmail.com>
	 <Pine.LNX.4.64.0706181217350.8899@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/07, Christoph Lameter <clameter@sgi.com> wrote:
> Stupid me. n on both sides of the comparison. Tried to run your script
> here but I cannot trigger it.
>
> Next attempt: Sorry for the churn.

Problem fixed. Thanks!

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
