Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbXLEWBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbXLEWBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 17:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbXLEWBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 17:01:37 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:29829 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbXLEWBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 17:01:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=blF8+qXyOiXkWP/82OOBgufwn5a7YO1drPfiVnoH7FGqzolVesRp3k1D/NIdI8WQW2qWJTSmThWRzNRM6IZRd7TxnQo3wpSL78kFqcO4udTHWI80xWFFRHvCvY9SyAUalU+av7vj8ViJ+/2OlNIQeRoFka8rJMriaX63RfSlKCA=
Message-ID: <6934efce0712051401x2b137420hb04f971e1ca2cbf6@mail.gmail.com>
Date: Wed, 5 Dec 2007 14:01:33 -0800
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: solid state drive access and context switching
Cc: "Chris Friesen" <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071205002454.52ea755c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47548BF4.3010907@nortel.com>
	 <20071203230629.725f4c7a@the-village.bc.nu>
	 <6934efce0712040954v74cf0b4bk19b49988bc828233@mail.gmail.com>
	 <20071204203536.2bf6d025@the-village.bc.nu>
	 <6934efce0712041354n47c11d6ckbc7f4aa1e7c85f@mail.gmail.com>
	 <20071204232449.6148e152@the-village.bc.nu>
	 <6934efce0712041608w2e25587n6b2d738fa0265d9d@mail.gmail.com>
	 <20071205002454.52ea755c@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Probably about 1000 clocks but its always going to depend upon the
> workload and whether any other work can be done usefully.

Yeah.  Sounds right, in the microsecond range.  Be interesting to see data.

Anybody have ideas on what kind of experiments could confirm this
estimate is right?
