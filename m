Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYB0SUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYB0SUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbYB0SUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:20:04 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:45862 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbYB0SUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:20:03 -0500
Message-ID: <fa686aa40802271020w4ebf05b0w6745e82cb4b51107@mail.gmail.com>
Date: Wed, 27 Feb 2008 11:20:02 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>,
       "Josh Boyer" <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH] [POWERPC] [v2] Xilinx: hwicap: cleanup
Cc: git-dev@xilinx.com, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
In-Reply-To: <20080224233457.C983D78006D@mail33-sin.bigfish.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080224232152.CEC5F12C8057@mail99-dub.bigfish.com>
	 <20080224233457.C983D78006D@mail33-sin.bigfish.com>
X-Google-Sender-Auth: 9438875638a4c654
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 4:34 PM, Stephen Neuendorffer
<stephen.neuendorffer@xilinx.com> wrote:
> Fix some missing __user tags and incorrect section tags.
>  Convert semaphores to mutexes.
>  Make probed_devices re-entrancy and error condition safe.
>  Fix some backwards memcpys.
>  Some other minor cleanups.
>  Use kerneldoc format.
>
>  [v2]
>  __user char => char __user
>  removed unused hwicap_command_capture
>  Fixed a comment that didn't match the function name
>  fixed argument with 'register' keyword.
>
>
>  Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Josh, can you please pick this up?

Thanks,
g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
