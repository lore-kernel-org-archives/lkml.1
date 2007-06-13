Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbXFMWxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbXFMWxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXFMWw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:52:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53747 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbXFMWwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:52:55 -0400
Date: Wed, 13 Jun 2007 15:52:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       =?ISO-8859-2?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Ian McDonald <ian.mcdonald@jandi.co.nz>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>, Dave Airlie <airlied@linux.ie>,
       Andrea Righi <righiandr@users.sourceforge.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [1/2] 2.6.22-rc4: known regressions with patches v3
In-Reply-To: <46704C47.40009@googlemail.com>
Message-ID: <Pine.LNX.4.64.0706131552250.32399@schroedinger.engr.sgi.com>
References: <46704C47.40009@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007, Michal Piotrowski wrote:

> Subject    : kernel BUG at mm/slub.c:3689!
> References : http://lkml.org/lkml/2007/6/11/121
> Submitter  : Haavard Skinnemoen <hskinnemoen@atmel.com>
> Handled-By : Christoph Lameter <clameter@sgi.com>
> Patch      : http://lkml.org/lkml/2007/6/11/405
>             http://lkml.org/lkml/2007/6/12/110
> Status     : patch was suggested

Patch was tested and submitted to Andrew on Monday.
