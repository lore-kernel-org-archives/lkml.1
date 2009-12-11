Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbZLKSDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbZLKSDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbZLKSC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:02:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59290 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZLKSC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:02:56 -0500
Message-ID: <4B228902.7010609@zytor.com>
Date: Fri, 11 Dec 2009 10:01:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Aristeu Rozanski <aris@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org,
       x86 <x86@kernel.org>
Subject: Re: [PATCH v2] x86, msr: add support for non-contiguous cpumasks
References: <20091207122133.GA24877@aftab> <4B21A50E.5090801@zytor.com> <20091211171440.GD31998@aftab>
In-Reply-To: <20091211171440.GD31998@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2009 09:14 AM, Borislav Petkov wrote:
> Ok, here's a second (and much leaner, removing a bunch of code) version.
> Tested on K8 and F10h machines here.

Much better, thanks!

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

