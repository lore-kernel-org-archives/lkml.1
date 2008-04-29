Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbYD2Gds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbYD2Gds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYD2Gdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:33:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:28572 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbYD2Gdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fTk1lj+snedjhCg3aeqqrO+qgvbS+LLPVkOA5qa4cTTHl+E9PRdKBQyyo3VTmy182gNz64TnhSc16IGYJ0PlZGG3VT9j0txcPbfk+ODb5+Qmc9RG8esWvP9xf46g4CqQfpQYqLFSVPBJCrVswY3CnjObzK+7rWnUnco2lymc39k=
Message-ID: <e2e108260804282333hefda3e1p485391d65a58fa21@mail.gmail.com>
Date: Tue, 29 Apr 2008 08:33:37 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "pradeep singh rautela" <rautelap@gmail.com>
Subject: Re: [Q]Can a file be dual licensed in upstream kernel?
Cc: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <greg@kroah.com>
In-Reply-To: <6bc632150804282237o1aa04e28t93f46874cd14721f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bc632150804282237o1aa04e28t93f46874cd14721f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 7:37 AM, pradeep singh rautela
<rautelap@gmail.com> wrote:
>  A small query.
>  Can a module/file be Dual licensed(i.e BSD/GPLv2) in the upstream
>  Linux kernel sources?
>  I think it is GPLv2 only.
>
>  So does this means any dual licensed files should be aptly GPLv2 only?

There are already source files in the Linux kernel that are dual
licensed. See e.g. drivers/infiniband/core/verbs.c. Note: not all
licenses are compatible. License compatibility is indeed not a topic
for the LKML mailing list.

Bart.
