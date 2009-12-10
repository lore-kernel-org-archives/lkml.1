Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbZLJHjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbZLJHjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760650AbZLJHjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:39:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34845 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760647AbZLJHjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:39:44 -0500
Message-ID: <4B20A577.7030401@zytor.com>
Date: Wed, 09 Dec 2009 23:38:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>, borislav.petkov@amd.com,
       Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Aristeu Rozanski <aris@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org,
       x86 <x86@kernel.org>
Subject: Re: [PATCH] x86, msr: add support for non-contiguous cpumasks
References: <20091207122133.GA24877@aftab> <20091210073514.GA7088@liondog.tnic>
In-Reply-To: <20091210073514.GA7088@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2009 11:35 PM, Borislav Petkov wrote:
> Hi Peter,
> 
> any nacks/acks on the fix below? Because we really need some version of
> it to go in now.
> 
> Thanks.
> 

Looks OK at a glance, but reviewing it is on tomorrow's list... too late
now, I'm sorry.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

