Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYHDK5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYHDK5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYHDK53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:57:29 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:31184 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752190AbYHDK52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:57:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=W0CEEGzmzBIkglDkWt7amwrhoSkIZqH5j0WS+4Gu5Ln4Rjk4ptp/nuPEBJrF5T+zaupZHNz3Io3GthVaxM+1a8mVHX/N7Sq21XbW3LCPx0nrQVthUa83sGV72+hhb8WvXL1WXnoqy/6fm818h4TKQTBqYOZ5ZcrnRgcIVTdhS8g=  ;
X-YMail-OSG: 2pMbSREVM1novQX4Ke9oBBb4DZR27Ffg6ClsYfu3uoK2GlCPT6svzdx4nP6RPqFc8GZKzeKhaIsqEYkHx8ONyGtIgjS8liNzTMWVVj2JpTuhDqfLmg1Qrm7IaR6xnAP68vc-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: lachlan@sgi.com
Subject: Re: [rfc][patch 3/3] xfs: use new vmap API
Date: Mon, 4 Aug 2008 20:57:20 +1000
User-Agent: KMail/1.9.5
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>, xfs@oss.sgi.com,
       xen-devel@lists.xensource.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net
References: <20080728123438.GA13926@wotan.suse.de> <20080728123703.GC13926@wotan.suse.de> <4896A197.3090004@sgi.com>
In-Reply-To: <4896A197.3090004@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808042057.20607.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for taking a look. I'll send them over to -mm with patch 1,
then, for some testing.

On Monday 04 August 2008 16:28, Lachlan McIlroy wrote:
> Looks good to me.
>
> Nick Piggin wrote:
> > Implement XFS's large buffer support with the new vmap APIs. See the vmap
> > rewrite patch for some numbers.

