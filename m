Return-Path: <linux-kernel-owner+w=401wt.eu-S2993264AbXDTPYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993264AbXDTPYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 11:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993269AbXDTPYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 11:24:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:28189 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993266AbXDTPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 11:24:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nzjug7OBqOiL0J4+IsozksabldlGy+dOpVCuhHxmho9B3teUlFi1wuBEpRGRBodbYb7xDEhlUgNr0l7TkCCK8ENmmYv4kfBX0jBfZZVXY6SghSQYAukApPv5NbLEDheUgFfJYw7qO9ObLgOsRtzGW+xDN5MBefYJ4+qaBABIMZE=
Message-ID: <a36005b50704200824i228f98ccq80f88a0f9d64abb2@mail.gmail.com>
Date: Fri, 20 Apr 2007 08:24:17 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andreas Gruenbacher" <agruen@suse.de>
Subject: Re: [d_path 0/7] Fixes to d_path: Respin
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200704201721.29825.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070412090809.917795000@suse.de>
	 <200704201345.09858.agruen@suse.de>
	 <a36005b50704200815j30c95caele31536948343e29a@mail.gmail.com>
	 <200704201721.29825.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, Andreas Gruenbacher <agruen@suse.de> wrote:
> Yes, that one, sorry. The values it obtains that way are not reliable.

Why should the mount point info together with the filesystem type not
be reliable?  You're trying to find an excuse to break tings, that
seems all there is.
