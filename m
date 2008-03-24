Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbYCXNeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbYCXNeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 09:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757056AbYCXNef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 09:34:35 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:64673 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbYCXNee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 09:34:34 -0400
Message-ID: <fa686aa40803240634o1f0ec81aj7745ea6ec44bdc32@mail.gmail.com>
Date: Mon, 24 Mar 2008 07:34:33 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [PATCH] [POWERPC] mpc5200: fix incorrect compatible string for the mdio node
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <18407.22329.130304.645554@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206156315-4734-1-git-send-email-grant.likely@secretlab.ca>
	 <18407.22329.130304.645554@cargo.ozlabs.ibm.com>
X-Google-Sender-Auth: 51c31fc964989094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 1:24 AM, Paul Mackerras <paulus@samba.org> wrote:
> Grant Likely writes:
>
>  > The MDIO node in the lite5200b.dts file needs to also claim compatibility
>  > with the older mpc5200 chip.
>  >
>  > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>  > ---
>  > Paul, this one should also go in for .26
>
>  OK, I'll put it in the powerpc-next branch.  Or did you mean it should
>  go in .25?

er, oops.  Yes, I really would like this one to go in for .25

Thanks,
g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
