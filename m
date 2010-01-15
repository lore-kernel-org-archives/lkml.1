Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab0AOQag (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 11:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757604Ab0AOQae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 11:30:34 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:62440 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757593Ab0AOQad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 11:30:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Kxj8Pt+xVVAUIs5WDdaP43YPuqofZmDs66DqfpWewBupne5DDdzVUeryFEFHin7dyX
         0z02VhWWhRiV/54lgXD4BV7f9CpHOixKRFtWhraOMtqZcKqDEWk5Oj40Ps0luEAaFbfb
         wTSFBlFtowQ4yL/iYOP4N76lz9X5wa9sZ5P2M=
Message-ID: <4B509857.6020600@gmail.com>
Date: Fri, 15 Jan 2010 08:31:19 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix some typo's in avc.c
References: <1263538998-20088-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1001151131180.30977@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1001151131180.30977@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/10 02:31, Jiri Kosina wrote:
> On Thu, 14 Jan 2010, Justin P. Mattock wrote:
>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> ---
>>   security/selinux/avc.c |    6 +++---
>>   1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/security/selinux/avc.c b/security/selinux/avc.c
>> index f2dde26..3328b1f 100644
>> --- a/security/selinux/avc.c
>> +++ b/security/selinux/avc.c
>> @@ -337,7 +337,7 @@ static inline struct avc_node *avc_search_node(u32 ssid, u32 tsid, u16 tclass)
>>    * Look up an AVC entry that is valid for the
>>    * (@ssid, @tsid), interpreting the permissions
>>    * based on @tclass.  If a valid AVC entry exists,
>> - * then this function return the avc_node.
>> + * then this function returns the avc_node.
>
> Applied, thanks.
>

your welcome.

Justin P. Mattock
