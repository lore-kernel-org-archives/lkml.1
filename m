Return-Path: <linux-kernel-owner+w=401wt.eu-S932320AbXGPPtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbXGPPtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbXGPPs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:48:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:58119 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbXGPPs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:48:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d3GiOldetl9d/R8I8+aN19IjgPfosniz6lO+iP4O0ICgXzNvEfAE/evr+0t1/ctPi3CslNNPDCdZVsa8uLi3QBzREd4BrBtAvIhjoIZsLIOxULuatXnnzXfMeEG0AEdXsgjzaMwkourijFAcE8Y0wXVZmDmcBDEwjZA/hP5avP8=
Message-ID: <a0a62dfc0707160848m5e3c3f47k3ea60ab3dec253c2@mail.gmail.com>
Date: Mon, 16 Jul 2007 10:48:52 -0500
From: "Adam Litke" <aglitke@gmail.com>
To: "Akinobu Mita" <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       "William Irwin" <wli@holomorphy.com>
Subject: Re: [PATCH] hugetlb: use set_compound_page_dtor
In-Reply-To: <20070714014638.GA5601@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070714014638.GA5601@APFDCB5C>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/13/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> Use appropriate accessor function to set compound page destructor
> function.
>
> Cc:  William Irwin <wli@holomorphy.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: Adam Litke <agl@us.ibm.com>

--
Adam Litke ( agl at us.ibm.com )
IBM Linux Technology Center
