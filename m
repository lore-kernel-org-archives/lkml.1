Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbZEIBoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbZEIBoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 21:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZEIBoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 21:44:01 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:39071 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbZEIBoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 21:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v9kK0aMQHUgLFPdZkTdFGsYE3STniaWAUt5VvBQLpEhgfkXtHeGxlT0SzksNuGX3Aa
         FYOshLSFOM7+hQKs4cspG/yj6go1XSz4ffhgFCSwxoj6Y97jTjDDBkkYhyv6tYr0GeYF
         RYia0qSDoYSy7Aln75mc3XvXLj83bNQY9EsH4=
MIME-Version: 1.0
In-Reply-To: <b6a2187b0905080222r53c7ed80s6d2ff91d386cd963@mail.gmail.com>
References: <1240855555.5529.11.camel@think.oraclecorp.com>
	 <b6a2187b0905080222r53c7ed80s6d2ff91d386cd963@mail.gmail.com>
Date: Sat, 9 May 2009 09:43:59 +0800
Message-ID: <b6a2187b0905081843p57b3ceeega3d54ee15cc997e3@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.30-rc
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 8, 2009 at 5:22 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> Also, would it be possible when creating a 300MB partition for "df" to
> display "50MB free" instead of "300MB free"?

Should display "46MB free" (256MB used by journal?).


Thanks,
Jeff.
