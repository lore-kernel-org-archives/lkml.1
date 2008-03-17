Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbYCQINR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbYCQINR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYCQINJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:13:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36750 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbYCQINI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:13:08 -0400
Date: Mon, 17 Mar 2008 09:15:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Paul Jackson <pj@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [4/18] Add basic support for more than one hstate in hugetlbfs
Message-ID: <20080317081533.GH27015@one.firstfloor.org>
References: <20080317258.659191058@firstfloor.org> <20080317015817.DE00E1B41E0@basil.firstfloor.org> <20080317030942.8465b09e.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080317030942.8465b09e.pj@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 03:09:42AM -0500, Paul Jackson wrote:
> Andi,
> 
> Seems to me that both patches 2/18 and 4/18 are called:
> 
>   Add basic support for more than one hstate in hugetlbfs
> 
> You probably want to change this detail.

Fixed thanks. Indeed description went wrong on 4/18
2/ was the correct one.

-Andi
