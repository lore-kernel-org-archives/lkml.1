Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbZLDKBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbZLDKBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZLDKBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:01:09 -0500
Received: from gate.crashing.org ([63.228.1.57]:60981 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbZLDKBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:01:08 -0500
Subject: Re: [PATCH] therm_adt746x: Don't access non-existing register
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20091204103434.0a754925@hyperion.delvare>
References: <20091202091951.5ec6bb83@hyperion.delvare>
	 <1259894454.2076.1246.camel@pasglop>
	 <20091204103434.0a754925@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 20:59:35 +1100
Message-ID: <1259920775.2076.1273.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 10:34 +0100, Jean Delvare wrote:
> 
> I've sent it to linuxppc-dev@ozlabs.org on October 14th. This is the
> address which is listed 22 times in MAINTAINERS. If it isn't correct,
> then please update MAINTAINERS.

No it's fine both shoul work. Your patches are there, just waiting for
me to pick them up, I was just firing a reminder to the rest of the CC
list :-) (and I do remember fwd'ing a couple of your patches to the
list, for some reason they didn't make it to patchwork back then, that
was a few month ago).

Anyways, I've been stretched thin with all sort of stuff lately, so bear
with me if I'm a bit slow at taking or testing stuff, I'm doing my best.

Cheers,
Ben.

