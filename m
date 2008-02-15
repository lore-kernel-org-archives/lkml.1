Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbYBOV4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbYBOV4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYBOVz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:55:59 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:54167 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbYBOVz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:55:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jWd6kB6/Q7JlCwiAmJoSOtqD1n1GUjHAsEChRFBlWtnbxIDwjPhHB4mJZ8vkCQWk8cdH+EN95Z0T1wU5VikUb6vrUYqm1ydLEMojQ/93uFfvxsrHWU2aJxowgxn1aOZ+jplrSA9VS8tJI7DbFryLz3y+DPGDgb+oL5TMOLXtMB0=
Message-ID: <43e72e890802151355y41215ee5x3f67cfa459d23c99@mail.gmail.com>
Date: Fri, 15 Feb 2008 16:55:57 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: matthias@kaehlcke.net, mcgrof@gmail.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 1/3] Convert acl->sem in a mutex
In-Reply-To: <20080215195648.GB22741@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215195329.912560854@kaehlcke.net>
	 <20080215195648.GB22741@traven>
X-Google-Sender-Auth: 94cbad15e0f75d78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 2:56 PM,  <matthias@kaehlcke.net> wrote:
> The semaphore acl->sem is used as mutex, convert it to the mutex API
>
>  Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
