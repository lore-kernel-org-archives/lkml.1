Return-Path: <linux-kernel-owner+w=401wt.eu-S1764351AbYESWZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764351AbYESWZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760858AbYESWZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:25:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:42923 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760471AbYESWZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:25:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c7x786x2KnGR6ZZg5EXA3RVlTR/CqriDBxyAKEZhlwwusm5jTRVJrdKPl1txq640uNnpOCtjSHaG8frGTRiX7k0T+D5F7sXfu+8Y3BolF4lZKAf+qWohiehwaSibARPPgA3YqIoDapfADCyzqWG/kPv9zdCWz8Bl13mu6rzvLbs=
Message-ID: <b6a2187b0805191525m5854c35aof52f40a337e67510@mail.gmail.com>
Date: Tue, 20 May 2008 06:25:01 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: recent 2.6.26 kernel hangs at suspend
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, len.brown@intel.com,
       "Shaohua Li" <shaohua.li@intel.com>, "Greg KH" <greg@kroah.com>
In-Reply-To: <200805191438.53323.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0805190807o7f6e87e1nd883607d603c893b@mail.gmail.com>
	 <200805191438.53323.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 2:38 AM, Len Brown <lenb@kernel.org> wrote:
> On Monday 19 May 2008, Jeff Chua wrote:

> Does this notebook have intel graphics?

Yes.

(II) intel(0): Integrated Graphics Chipset: Intel(R) 945GM

> If yes, does anything change with the i915 driver loaded vs not loaded?

I'll try that. Currently, everything compliled into kernel.

Thanks,
Jeff.
