Return-Path: <linux-kernel-owner+w=401wt.eu-S1763269AbYEUJGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763269AbYEUJGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYEUJFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:05:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbYEUJFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:05:51 -0400
Date: Wed, 21 May 2008 11:05:39 +0200
From: Karel Zak <kzak@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, Mark.Seger@hp.com
Subject: Re: [ANNOUNCE] util-linux-ng 2.14-rc3
Message-ID: <20080521090539.GK17439@nb.net.home>
References: <20080519112402.GF17439@nb.net.home> <20080520191704.ea856364.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520191704.ea856364.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 07:17:04PM -0700, Andrew Morton wrote:
> Have you considered adding collectl to util-linux?  If so, what was the
> outcome?

 The util-linux is a very basic system package and I'd like to avoid
 dependences on things like Perl.

 I don't see a problem to distribute collectl as a separate package.
 It seems that Mark is maintaining the package very successfully on
 sf.net.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
