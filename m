Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbZKBQT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbZKBQT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbZKBQT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:19:27 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:4473 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbZKBQT0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com;3:1>);
	Mon, 2 Nov 2009 11:19:26 -0500
Message-Id: <4AEEC03D0200005A00057D47@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 02 Nov 2009 09:19:25 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Thadeu Lima de Souza Cascardo" <cascardo@holoscopio.com>,
       "Jiri Kosina" <jkosina@suse.cz>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: fix a typo in SHM_SIGNAL config
	 description
References: <1256938012-8088-1-git-send-email-cascardo@holoscopio.com>
 <alpine.LSU.2.00.0911021653250.4203@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0911021653250.4203@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11/2/2009 at 10:54 AM, in message
<alpine.LSU.2.00.0911021653250.4203@wotan.suse.de>, Jiri Kosina
<jkosina@suse.cz> wrote: 
> On Fri, 30 Oct 2009, Thadeu Lima de Souza Cascardo wrote:
> 
>> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>> ---
>>  lib/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/lib/Kconfig b/lib/Kconfig
>> index 272cecf..bfe871d 100644
>> --- a/lib/Kconfig
>> +++ b/lib/Kconfig
>> @@ -207,7 +207,7 @@ config SHM_SIGNAL
>>  	tristate "SHM Signal - Generic shared-memory signaling mechanism"
>>  	default n
>>  	help
>> -	 Provides a shared-memory based signaling mechansim to indicate
>> +	 Provides a shared-memory based signaling mechanism to indicate
>>           memory-dirty notifications between two end-points.
>>  
>>  	 If unsure, say N
> 
> This doesn't apply on top of current Linus' tree. Gregory, I guess you'll 
> be taking this one together with your pile that's currently in -next, 
> right?

Yep, Ill pull it to my tree shortly.  Thanks, all.

-Greg





