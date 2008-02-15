Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbYBOVza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbYBOVza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbYBOVzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:55:20 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:54085 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbYBOVzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:55:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xd0m6bEkAlq8zumdYqnqmW3ruqDb+zWgaASHnvMI+pBAWvlYlN6bEK+n4khweoJAV0BGeEE6nOeoGv+q/RWVF9L6Qzn1YZaxzCEIkP+7QwU24KJb0dXgZIDH6PyG2n6jacuhLhVo3wD1VJ1nkKWR9nlSIeL7CrLTgAtOORfqDFA=
Message-ID: <43e72e890802151355x3bab40beib98feb887e0baacb@mail.gmail.com>
Date: Fri, 15 Feb 2008 16:55:16 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: matthias@kaehlcke.net, mcgrof@gmail.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 2/3] Convert stats_sem in a mutex
In-Reply-To: <20080215195659.GC22741@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215195329.912560854@kaehlcke.net>
	 <20080215195659.GC22741@traven>
X-Google-Sender-Auth: cb9865b097b50eb4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 2:56 PM,  <matthias@kaehlcke.net> wrote:
> The semaphore stats_sem is used as mutex, convert it to the mutex API
>
>  Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

Thanks, BTW, for the next set you send please review the linux
wireless submitting patch guide. You just need to address the patch to
John, the maintainers and CC linux-wireless.

http://linuxwireless.org/en/developers/Documentation/SubmittingPatches

  Luis
