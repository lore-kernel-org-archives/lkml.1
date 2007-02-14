Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbXBNKl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbXBNKl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932202AbXBNKl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:41:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:54996 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbXBNKl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:41:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=my4TqfoIvnJzINjWju/FBS82sRnFbiu84dpEXZKlw738VwvQbiEQBvylTrlOX/mv+o3EEdHNLNcDqfipFwBMeDL207rJsoSQUQG2h4EVgQZIbX1IhVxnCXdLwdasXpWeKZZ0BN8OOnCWFd3DkmlRrJF7NO9vCjTV1sAz6xeZULk=
Message-ID: <81b0412b0702140241tdf0854dl61384fb1f64bb637@mail.gmail.com>
Date: Wed, 14 Feb 2007 11:41:56 +0100
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Shaohua Li" <shaohua.li@intel.com>
Subject: Re: [PATCH]microcode update driver rewrite - takes 2
Cc: "Tigran Aivazian" <tigran@veritas.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1151376693.21189.52.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1151376693.21189.52.camel@sli10-desk.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/06, Shaohua Li <shaohua.li@intel.com> wrote:
> With the changes, we should put all intel-ucode/xx-xx-xx microcode files
> into the firmware dir (I had a tool to split previous big data file into
> small one and later we will release new style data file).

BTW, where this tool can be found? At the moment we seem to have
only microcode_ctl, and microcode.dat from it distribution is not understood
by the driver.
