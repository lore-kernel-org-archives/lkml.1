Return-Path: <linux-kernel-owner+w=401wt.eu-S1759112AbYEEOcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112AbYEEOcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756768AbYEEOby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:31:54 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:36589 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613AbYEEObx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:31:53 -0400
Message-ID: <fa686aa40805050731gc29e88hdc4917041a63e12f@mail.gmail.com>
Date: Mon, 5 May 2008 08:31:52 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: monstr@seznam.cz
Subject: Re: [PATCH 10/56] microblaze_v2: Generic dts file for platforms
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       "Michal Simek" <monstr@monstr.eu>
In-Reply-To: <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
	 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
X-Google-Sender-Auth: 1e814cfabf66a8e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 5:40 AM,  <monstr@seznam.cz> wrote:
> From: Michal Simek <monstr@monstr.eu>
>
>
>  Signed-off-by: Michal Simek <monstr@monstr.eu>
>  ---
>   arch/microblaze/platform/generic/system.dts |  137 +++++++++++++++++++++++++++

What is the purpose of the generic dts?  Will this work with custom
microblaze designs?  The header block should contain a comment about
what this file is for.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
