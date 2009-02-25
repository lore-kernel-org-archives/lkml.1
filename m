Return-Path: <linux-kernel-owner+w=401wt.eu-S1761657AbZBYJis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761657AbZBYJis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZBYJij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:38:39 -0500
Received: from mx0.towertech.it ([213.215.222.73]:56432 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751316AbZBYJii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:38:38 -0500
Date: Wed, 25 Feb 2009 10:38:30 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, tiwai@suse.de, katzj@redhat.com,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       perex@perex.cz, cjb@laptop.org, linux-geode@lists.infradead.org,
       jayakumar.alsa@gmail.com
Subject: Re: [PATCH 1/2] cs553x-gpio: add AMD CS5535/CS5536 GPIO driver
 support
Message-ID: <20090225103830.4b416a1c@i1501.lan.towertech.it>
In-Reply-To: <20090224151937.6bf43943@ephemeral>
References: <20090220221202.667fbb79@ephemeral>
	<20090224120637.18073f93.akpm@linux-foundation.org>
	<20090224151937.6bf43943@ephemeral>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 15:19:37 -0500
Andres Salomon <dilinger@queued.net> wrote:

> Not yet.  The MFGPT, DCON, and olpc stuff will use them; I'm waiting to
> hear feedback on this patch before I write a generic MFGPT driver (or
> skip to cleaning up and submitting the DCON driver).
> 

 why can't they use the generic gpio api?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

