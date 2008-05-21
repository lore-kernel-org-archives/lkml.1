Return-Path: <linux-kernel-owner+w=401wt.eu-S1765318AbYEUJNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765318AbYEUJNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYEUJNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:13:10 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64542 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753795AbYEUJNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:13:09 -0400
Date: Wed, 21 May 2008 10:11:36 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Karel Zak <kzak@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       Mark.Seger@hp.com
Subject: Re: [ANNOUNCE] util-linux-ng 2.14-rc3
In-Reply-To: <20080521090539.GK17439@nb.net.home>
Message-ID: <Pine.LNX.4.55.0805211007340.31790@cliff.in.clinika.pl>
References: <20080519112402.GF17439@nb.net.home> <20080520191704.ea856364.akpm@linux-foundation.org>
 <20080521090539.GK17439@nb.net.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Karel Zak wrote:

> > Have you considered adding collectl to util-linux?  If so, what was the
> > outcome?
> 
>  The util-linux is a very basic system package and I'd like to avoid
>  dependences on things like Perl.

 Does collectl require Perl for building?  If it has a run-time dependency
only, then it does not really differ from chkdupexe and it is up to
whoever makes a distribution to partition binary packages in a sensible
way.

  Maciej
