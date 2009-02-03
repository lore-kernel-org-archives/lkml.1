Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbZBCJt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbZBCJt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZBCJtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:49:47 -0500
Received: from smtp.nokia.com ([192.100.122.230]:19443 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZBCJtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:49:46 -0500
Subject: Re: [BUGFIX re-send] [PATCH] write-back: fix nr_to_write counter
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>, npiggin@suse.de,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200902032045.16829.nickpiggin@yahoo.com.au>
References: <1233650542.24809.54.camel@localhost.localdomain>
	 <200902032013.57438.nickpiggin@yahoo.com.au>
	 <1233653569.24809.69.camel@localhost.localdomain>
	 <200902032045.16829.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Feb 2009 11:47:52 +0200
Message-Id: <1233654472.24809.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Feb 2009 09:47:47.0735 (UTC) FILETIME=[787E4A70:01C985E4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 20:45 +1100, Nick Piggin wrote:
> > > Can you cc stable@kernel.org when a final version gets merged upstream
> > > please?
> >
> > Sure, I just want to get blessing of one of MM/FS gurus. E.g. you
> > Acked-by would be enough.
> 
> Yes please put an Acked-by: Nick Piggin <npiggin@suse.de> on there.
> But I found your comments in this mail to be easier to understand.
> Perhaps incorporate them into the changelog?

Will do and re-send it.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

