Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbZLQXtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbZLQXtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZLQXtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:49:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZLQXtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:49:40 -0500
Message-ID: <4B2AC394.4030108@redhat.com>
Date: Thu, 17 Dec 2009 18:49:40 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Sam Ravnborg <sam@ravnborg.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, rdreier@cisco.com, mmarek@suse.cz,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] Makefile: set LC_CTYPE, LC_COLLATE,	LC_NUMERIC
 to C
References: <4B2A1761.4070904@suse.cz> <tip-c051346b7db27aaf674b8f3b4955240580b2a58a@git.kernel.org> <20091217220951.GB4236@merkur.ravnborg.org> <4B2AB07D.5010007@zytor.com> <4B2AC01E.6090509@redhat.com> <4B2AC0C0.4000005@zytor.com> <4B2AC198.1010508@redhat.com> <4B2AC280.2060603@zytor.com>
In-Reply-To: <4B2AC280.2060603@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 12/17/2009 03:41 PM, Masami Hiramatsu wrote:
>>>
>>> What happens if you remove that part?
>>
>> Commented out LC_ALL= as below;
>>
> 
> OK, what about the "unexport" variant?

Sure, unexport variant fixed it too.



-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

