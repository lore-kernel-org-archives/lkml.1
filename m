Return-Path: <linux-kernel-owner+w=401wt.eu-S1030208AbXBOQ57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030208AbXBOQ57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030215AbXBOQ5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:57:42 -0500
Received: from adelie.ubuntu.com ([82.211.81.139]:59582 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030208AbXBOQ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:57:25 -0500
Subject: Re: p4-clockmod N60 errata workaround.
From: Ben Collins <ben.collins@ubuntu.com>
To: Oscar Pearce <opearce@gmail.com>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <598fb2280702150837h33b73f3u2c5efe7838f7d420@mail.gmail.com>
References: <20061028195349.GH27101@redhat.com>
	 <598fb2280702150837h33b73f3u2c5efe7838f7d420@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 15 Feb 2007 11:56:57 -0500
Message-Id: <1171558617.7473.14.camel@gullible>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.6 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 10:37 -0600, Oscar Pearce wrote:
> On 10/28/06, Dave Jones <davej@redhat.com> wrote:
>         Ben,
>         For the best part of a year since that N60 errata workaround
>         went in, I've had floods of complaints from users of that
>         driver
>         about this driver becoming even more useless than it was
>         before
>         "I had 8 frequencies, now I have 2" being the common
>         complaint. 
>         which was to be expected given that the intention of the
>         errata
>         workaround was to cripple frequencies <2GHz.

We've since removed that patch from our current tree. It might remain in
some older kernels. I'll definitely check into getting it pulled from
there next update we do for them.

Thanks.

> 
-- 
Ubuntu:    http://www.ubuntu.com/
Linux1394: http://www.linux1394.org/

