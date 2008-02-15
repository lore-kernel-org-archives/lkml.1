Return-Path: <linux-kernel-owner+w=401wt.eu-S1759965AbYBOV5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbYBOV5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759932AbYBOV4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:56:34 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:53999 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759773AbYBOV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:56:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OEaxMYH2oJ6DrFbX/001UnB+dc0B756fo29+xXTsgLA49lE9YOY1/3YsrFmxPnbWkNiR9ITkS0VgZP9imhTBNkoqBLibhYNale+ruN2nNoI062tr3TiePbPBOnym0DYJu6A1MHBq2qpwYcPTlsz31v5jnE+s3XwzgTyKS8ii8pQ=
Message-ID: <43e72e890802151356x52ce6ac5l8adf21374d9cf832@mail.gmail.com>
Date: Fri, 15 Feb 2008 16:56:30 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: matthias@kaehlcke.net, mcgrof@gmail.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch 3/3] Convert wpa_sem in a mutex
In-Reply-To: <20080215195707.GD22741@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215195329.912560854@kaehlcke.net>
	 <20080215195707.GD22741@traven>
X-Google-Sender-Auth: 1b72a52043eb662b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 2:57 PM,  <matthias@kaehlcke.net> wrote:
> The semaphore wpa_sem is used as mutex, convert it to the mutex API
>
>  Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
