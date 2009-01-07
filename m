Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZAGQK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZAGQK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZAGQKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:10:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:28555 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbZAGQKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:10:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QNA3PSiw26LBe0hVFDHwXAdgLh8H0m76fUq1PzQwQEH7L8jZnkmbV/SwKSBDjEReoP
         7d9uphuGc4o5WHhVWEKf1HQ7RiEIu2YZCuztNXf9dTrAOE9R5CH7jnLYvK+IyIjfABws
         urCLA2A6G8bGEeUHy1EiamYmpNWeFxw2EIBJo=
Message-ID: <4964D403.3090709@gmail.com>
Date: Wed, 07 Jan 2009 17:10:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpu: create stop machine in disable_nonboot_cpus
References: <1231342755-5122-1-git-send-email-jirislaby@gmail.com> <20090107160039.GB25560@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090107160039.GB25560@osiris.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2009 05:00 PM, Heiko Carstens wrote:
> Yep, it's exactly the same what I had as well:

Great ;).
