Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbXFOXzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbXFOXzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXFOXzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:55:09 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:61478 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbXFOXzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:55:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YvoGmdx5dle+OiX7KM22SwIWUgIp8KunqsoEaL7C7pKnkcTrkcj6d7u1LbO+H57M1fjHgMMcPP1CZ+TP8N761OkXWaRmKbn+3YcryYYScp8oK1dbjB9hkDhvc0Apq01Lbx1BmsafNF8kB/gS7lD/djoiG9+1sBSrQ8566MAaZpc=
Message-ID: <e9c3a7c20706151655j6cdc5307qe544b8a3a2f156a4@mail.gmail.com>
Date: Fri, 15 Jun 2007 16:55:05 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: raid5: coding style cleanup / refactor
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
In-Reply-To: <18035.5414.680663.405523@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181670063.12913.5.camel@dwillia2-linux.ch.intel.com>
	 <18035.5414.680663.405523@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, Neil Brown <neilb@suse.de> wrote:
> Good idea...  Am I asking too much to have separate things in separate
> patches?  It makes review easier.
>
...yeah I got a little bit carried away after the refactoring.  I will
spin the refactoring out into a separate patch and handle the coding
style violations as you suggested.

> NeilBrown

Thanks,
Dan
