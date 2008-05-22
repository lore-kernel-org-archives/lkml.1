Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbYEVCmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbYEVCmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 22:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbYEVCml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 22:42:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:32873 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbYEVCmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 22:42:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZuHnl4sYYRSRVaporQ97319VdZrDIgWLsSryaSYGbDFukk1hhggVyxz+ZzRnLq5tzkXkrXdzj5XlpdXVZWxZSw7v5qj4ie15lFyTJZxIZo59PTY2lk8wltcycUG670EEjhEm7mdePI0kZCPVHEWQgInJD1TU5HekxTzWT6y2zxY=
Message-ID: <1820d69d0805211942v36fa54edh216a14efae9ebdde@mail.gmail.com>
Date: Thu, 22 May 2008 04:42:39 +0200
From: "Gabriel C" <nix.or.die@googlemail.com>
To: "Tony Breeds" <tony@bakeyournoodle.com>
Subject: Re: linux-next: [PATCH] infiniband/hw/ipath/ipath_sdma.c , fix compiler warnings
Cc: rolandd@cisco.com, "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org, sean.hefty@intel.com,
       hal.rosenstock@gmail.com, linux-next@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080522002335.GG20457@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48342C6C.2010502@googlemail.com>
	 <20080522002335.GG20457@bakeyournoodle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/22 Tony Breeds <tony@bakeyournoodle.com>:
> On Wed, May 21, 2008 at 04:06:36PM +0200, Gabriel C wrote:
>> On linux-next from today , allmodconfig, I see the following warnings on 64bit:
>
> x86_64 right?
>

Yes it is x86_64
