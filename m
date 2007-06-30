Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbXF3OND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbXF3OND (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbXF3OMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:12:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:64406 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbXF3OMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:12:54 -0400
Message-ID: <fa686aa40706300712w306243e0ob1242ebc28442071@mail.gmail.com>
Date: Sat, 30 Jun 2007 10:12:53 -0400
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Akinobu Mita" <akinobu.mita@gmail.com>
Subject: Re: [PATCH 2/4] void unregister_blkdev - delete redundant messages
Cc: linux-kernel@vger.kernel.org, "Eberhard Moenkeberg" <emoenke@gwdg.de>,
       "Joe Thornber" <dm-devel@redhat.com>
In-Reply-To: <961aa3350706300708l3bd4ab31ob9646847ea4f4537@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070630031013.GC4045@APFDCB5C> <20070630031212.GD4045@APFDCB5C>
	 <fa686aa40706292314g3323c98dxdecd8b5a289f1c64@mail.gmail.com>
	 <961aa3350706300708l3bd4ab31ob9646847ea4f4537@mail.gmail.com>
X-Google-Sender-Auth: 046d64ae8acb1676
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/07, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> > Seeing as none of the callers check the error code; why does the
> > function return anything at all?
>
> Right. This series of patches is trying to make it return void.
>
> http://lkml.org/lkml/2007/6/29/320

Heh, cool.  I should do more research before I reply blindly.  :-)

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
