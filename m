Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbXLGD1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbXLGD1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 22:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbXLGD1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 22:27:05 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:13259 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbXLGD1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 22:27:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=u1S5PsXSPTQYysSHkNwWGrhrpXuHHFugdc5YHLzhf+IzdyrBV57zlrvgmCUN0ddtRyyMNFmhAuH6KecxF/JHfrFJe73ZrplY4fGArXNi29yDag2J66Cb3XKQxGL1NU1jqZhpkIvre86MCYJdSXNd2yGRivXQfIt6SfvNlZMxHwQ=
Message-ID: <a44ae5cd0712061927y117d5b74qef8acea62a84925f@mail.gmail.com>
Date: Thu, 6 Dec 2007 22:27:02 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH x86/mm] x86 vDSO: canonicalize sysenter .eh_frame
Cc: "Roland McGrath" <roland@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Laurent Riffard" <laurent.riffard@free.fr>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1196990853.22471.15.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	 <47587796.8020705@free.fr>
	 <20071206143754.07a67819.akpm@linux-foundation.org>
	 <20071207011429.EE2BC26F8D9@magilla.localdomain>
	 <1196990853.22471.15.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.  That enabled me to compile as well.  Now, if I can figure out
why the resulting kernel has a boot process that hangs...  :-)

     Miles
