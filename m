Return-Path: <linux-kernel-owner+w=401wt.eu-S1763879AbXJQM7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763879AbXJQM7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 08:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbXJQM7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 08:59:08 -0400
Received: from c60.cesmail.net ([216.154.195.49]:40774 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbXJQM7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 08:59:06 -0400
Message-ID: <20071017085905.pshy2ctghwk8skcc@webmail.spamcop.net>
Date: Wed, 17 Oct 2007 08:59:05 -0400
From: Pavel Roskin <proski@gnu.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Distinguishing releases from pre-rc snapshots
References: <1192587763.3672.24.camel@dv>
	<E1Ii1zU-0002Cj-EC@faramir.fjphome.nl>
In-Reply-To: <E1Ii1zU-0002Cj-EC@faramir.fjphome.nl>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Frans Pop <elendil@planet.nl>:

> Note that you can see if there have been commits since a release   
> (the last git tag) by using the command 'git describe'.
>
> $ git checkout -b temp v2.6.23
> Switched to a new branch "temp"
> $ git describe
> v2.6.23
> $ git checkout master
> $ git describe
> v2.6.23-4223-g65a6ec0
>
> Format is: last tag - # commits since last tag - id of HEAD commit

I don't see how I can use it in preprocessor conditions.

-- 
Regards,
Pavel Roskin
