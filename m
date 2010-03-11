Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549Ab0CKWWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:22:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757257Ab0CKWWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:22:18 -0500
Message-ID: <4B996CE1.5010902@redhat.com>
Date: Thu, 11 Mar 2010 17:21:21 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dieter Ries <mail@dieterries.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OPTPROBES: Don't default to y in Kconfig
References: <1268089658-19919-1-git-send-email-mail@dieterries.net> <4B967000.5070904@redhat.com> <20100311131501.GB11837@elte.hu>
In-Reply-To: <20100311131501.GB11837@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Dieter Ries wrote:
>>> CONFIG_OPTPROBES should not default to y while still being flagged
>>> EXPERIMENTAL.
>>
>> Hm, OK, indeed it still needs some more user tests.
>>
>> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
> 
> Well, since this is a prime time optimization i'd rather see the Kconfig value 
> eliminated and the optimization to become unconditional. (if it doesnt work 
> somewhere then it should be fixed)

OK, that will be good for finding bugs. :) 

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
