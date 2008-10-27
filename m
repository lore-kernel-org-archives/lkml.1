Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbYJ0Sc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbYJ0Sc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYJ0ScU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:32:20 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:53987 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYJ0ScU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:32:20 -0400
Date: Mon, 27 Oct 2008 11:32:09 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ibmpex: trivial endian annotation in extract_data
	helper
Message-ID: <20081027183209.GU7771@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <1224891898.5784.0.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224891898.5784.0.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 04:44:58PM -0700, Harvey Harrison wrote:
> This helper is used in few enough locations that open-coding it
> at the call sites may be better than the helper.

I'm not sure how this comment relates to the diff.

That said, the diff itself is ok by me.

--D
