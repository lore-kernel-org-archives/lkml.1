Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbXJAIJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbXJAIJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 04:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXJAIJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 04:09:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:55687 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbXJAIJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 04:09:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HJRnlY/tEnke+COFFXfhe0WvXXYJCsOra/qEoW5anuJ85a1z6CzOhAWnXHYfqFPQ5Xwpo3FhIXparhDszHykU3jGi8eOwrfYa9MoLLvs9enoT02mYBYhRTk/t+ToPFEpEIQJ2Hqrdb0NrWuYodEP+lPX7saH4O9nvq/7e/mCuTg=
Message-ID: <4700AB1E.9020800@gmail.com>
Date: Mon, 01 Oct 2007 10:09:02 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Paolo Ornati <ornati@fastwebnet.it>, Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
References: <fa.ernzRd7lGBTxTXHl/DtyMhz/rPk@ifi.uio.no> <47003525.7040407@shaw.ca>
In-Reply-To: <47003525.7040407@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2007 01:45 AM, Robert Hancock wrote:
> Are you sure this isn't just a bum drive? Looking at the SMART listing
> that was posted, looks like it's had some uncorrectable sector read
> errors in the event log..

Seagate is known to report wrong numbers in smart.

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
