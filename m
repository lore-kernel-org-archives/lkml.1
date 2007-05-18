Return-Path: <linux-kernel-owner+w=401wt.eu-S1761827AbXERAB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761827AbXERAB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 20:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbXERABu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 20:01:50 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:14701 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbXERABt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 20:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PiKibzbO/dlY1G4hSHbn2Jbh4xxrKNwKuvhYHqMTKpwXdLPWdAhmjQzhpbnaBvTORbOVb7vyjrW+Zq7KREykwiAJfWRs+LicYbR48B1OIOQbZVbXtH0i05eDWdYc2/sWeIDsh7IgZJOsNeHF+jIfWaVgWdHaJhOajZpaa7Cgk0Y=
Message-ID: <7fe698080705171701w533767fdo6642bb772ed64273@mail.gmail.com>
Date: Fri, 18 May 2007 09:01:48 +0900
From: "Dongjun Shin" <djshin90@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH] LogFS take three
Cc: "David Woodhouse" <dwmw2@infradead.org>,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, "Albert Cahalan" <acahalan@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, "Greg KH" <greg@kroah.com>,
       "Ingo Oeser" <ioe-lkml@rameria.de>
In-Reply-To: <20070517201847.GA5032@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070515151919.GA32510@lazybastard.org>
	 <20070515133759.9ee434a2.akpm@linux-foundation.org>
	 <1179317240.2859.222.camel@shinybook.infradead.org>
	 <20070516083408.dcd9dd78.akpm@linux-foundation.org>
	 <1179330596.2859.248.camel@shinybook.infradead.org>
	 <20070516164158.GB8113@lazybastard.org>
	 <7fe698080705162312t4e7ed90byd10ef8e664027b17@mail.gmail.com>
	 <1179383117.2859.416.camel@shinybook.infradead.org>
	 <7fe698080705170120w18fe5521oa685cf248a45e1c6@mail.gmail.com>
	 <20070517201847.GA5032@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 5/18/07, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>
> Hmm.. so operating your camera on batteries should be against the
> warranty, since batteries commonly run empty while storing pictures?
>
>

AFAIK, the camera stops writing to the flash card and automatically
turns off when it's low on battery (before empty).
