Return-Path: <linux-kernel-owner+w=401wt.eu-S1762049AbYEGEk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762049AbYEGEk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYEGEkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 00:40:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:20467 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYEGEks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 00:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CNp5CWxzJoxOkmQJhtGst99uF5BjZtrTYJQklh/ZP6Qt7JCga1c5/IcL5XIRrDiC8xHpAj+Uw1/QJanQnfObYixJRtRsZGigTexJCjwWhr7vDnqaUT7yMUoa/mKnbOD7o7Ta7C1KglIICy0mdqzHhBuO+ozTyAT7aST4jH0eS7E=
Message-ID: <b6a2187b0805062140i2546a1a8pc3fa65227a9873ab@mail.gmail.com>
Date: Wed, 7 May 2008 12:40:44 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
Cc: "Hans Rosenfeld" <hans.rosenfeld@amd.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Nishanth Aravamudan" <nacc@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0805062043580.11647@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com>
	 <20080506124946.GA2146@elte.hu>
	 <Pine.LNX.4.64.0805061435510.32567@blonde.site>
	 <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0805062043580.11647@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 3:49 AM, Hugh Dickins <hugh@veritas.com> wrote:

>  Signed-off-by: Hugh Dickins <hugh@veritas.com>

Hugh,

Thanks for the patch. It's in Linus's git now and I just booted 2 Dell
2950 and both are no showing the errors.


Thanks,
Jeff.
