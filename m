Return-Path: <linux-kernel-owner+w=401wt.eu-S933453AbXJQVtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbXJQVtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 17:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbXJQVtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 17:49:32 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:55066 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbXJQVtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 17:49:31 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] rd: Mark ramdisk buffers heads dirty
Date: Wed, 17 Oct 2007 23:48:23 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
References: <200710151028.34407.borntraeger@de.ibm.com> <200710171814.01717.borntraeger@de.ibm.com> <m1sl49ei8x.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1sl49ei8x.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710172348.23113.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 17. Oktober 2007 schrieb Eric W. Biederman:
> Did you have both of my changes applied?
> To init_page_buffer() and to the ramdisk_set_dirty_page?

Yes, I removed my patch and applied both patches from you. 

Christian
