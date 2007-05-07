Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXEGLFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXEGLFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 07:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbXEGLFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 07:05:37 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:58883 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768AbXEGLFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 07:05:36 -0400
Date: Mon, 7 May 2007 13:04:42 +0200
From: Cornelia Huck <huckc@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg K-H <greg@kroah.com>
Subject: Re: 2.6.21-mm1
Message-ID: <20070507130442.6ee9259e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007 01:49:55 -0700,
Andrew Morton <akpm@linux-foundation.org> wrote:

> +s390-fix-subsystem-removal-fallout.patch
> 
>  Fix it.

It doesn't, since the subsystem removal doesn't seem to be applied
(although it is present in the broken-out directory).
