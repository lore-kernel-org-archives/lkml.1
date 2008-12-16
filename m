Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYLPN0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYLPN0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 08:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbYLPN0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 08:26:13 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:44339 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbYLPN0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 08:26:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e4mNEvvfTeDmTbgLbsxygOfXwVV3BgK9u4dUDxJpEC4sTe1wcXa68mTjZ3yLRsnVu9
         Bz7rnF+Ump4YCeAlb8xKvEMgV456ktFg4e+79H3aZ6GO4iove8KlUzAfh48N07ILSZ66
         1a646l11ojbgBophKVHoudt54CbrVRVYq6E0g=
Date: Tue, 16 Dec 2008 15:26:32 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org
Subject: Re: kmemtrace
Message-ID: <20081216132632.GA5382@localhost>
References: <20081205112929.GA8497@x200.localdomain> <20081214160717.GA5361@localhost> <20081214184041.GA21547@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081214184041.GA21547@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 01:40:41PM -0500, Mathieu Desnoyers wrote:
> 
> Have you switched to tracepoints rather than markers for kmemtrace ?
> 
> Mathieu
> 

No, but I'll do it ASAP, good point. I totally forgot they made it in
Linus' tree.


	Thanks,
	Eduard

