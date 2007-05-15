Return-Path: <linux-kernel-owner+w=401wt.eu-S965821AbXEORg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965821AbXEORg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759692AbXEORgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:36:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:16119 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758480AbXEORgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:36:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=m+SV3ttYDiBP3VQ2w0PyuXHuf4GPfvligSHfDLLpdh1veCHZIvpIAJW/c1O6/xo6C1/iQE9wYRbbVMSahI+ZuBvMrpFzJjlKfdBF3Q9x2vdqu4hkVq6+E3WqW4jez5Se17Ec5eAERRELD3L7cpVEejLq/Fy7/wv8ZLoTMdU4y1I=
Message-ID: <4649EFA4.9060000@gmail.com>
Date: Tue, 15 May 2007 19:36:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@us.ibm.com>
CC: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: select(0, ..) is valid ?
References: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com>
In-Reply-To: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Badari Pulavarty napsal(a):
> Hi,
> 
> Is select(0, ..) is a valid operation ?

Yes, it was (is) sometimes used for measuring (sleeping for) short time slices.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
