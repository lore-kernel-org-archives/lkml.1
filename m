Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbYDNNoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbYDNNoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYDNNoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:44:00 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:49076 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYDNNoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=r9+JniLSqZMpyx6WNGYCzl3pclG07W1hyACbxFEWvjLwJ5hhNxNGyf9EeAyGd2UxSy9IafaLNOJz84sxcO5/FGQwUhlAXymRIFEpptz+7nPQEWaksRff7zaZfYd22p2SEY7FHVJQwpVBtzDDb5Y8FdxjZm/+rEDaBvq56XEPWUc=
Message-ID: <48035F98.1020404@gmail.com>
Date: Mon, 14 Apr 2008 15:43:52 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       York Sun <yorksun@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org
Subject: Re: [PATCH 1/2] Driver for Freescale 8610 and 5121 DIU
References: <12053582234100-git-send-email-yorksun@freescale.com>	<12053582231281-git-send-email-yorksun@freescale.com>	<47D8572C.8090501@gmail.com>	<47FFDBFF.1030809@gmail.com> <20080411221817.0b1eb414.akpm@linux-foundation.org> <48035E93.6070300@freescale.com>
In-Reply-To: <48035E93.6070300@freescale.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2008 03:39 PM, Timur Tabi wrote:
> Andrew Morton wrote:
> 
>> Thanks.  I've made a note that this patch has outstanding issues.  Usually
>> this means that I'll defer merging it until they have been addressed:
>> either by fixing them or by successfully arguing against the objections.  
> 
> Sorry, I must have gotten out of sync.  What are the outstanding issues?  I was
> under the impression that the latest patch (v5) resolved everything.  In fact,
> the last email from you (dated 4/1) said that you picked it up, minus the defconfig.

See
http://lkml.org/lkml/2008/3/12/375
