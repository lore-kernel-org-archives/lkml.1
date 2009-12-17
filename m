Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbZLQDli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbZLQDli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 22:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934847AbZLQDl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 22:41:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990AbZLQDlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 22:41:23 -0500
Message-ID: <4B29A8F3.3090306@redhat.com>
Date: Wed, 16 Dec 2009 22:43:47 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrew Isaacson <adi@vmware.com>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org> <20091217011932.GT14381@ZenIV.linux.org.uk>
In-Reply-To: <20091217011932.GT14381@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Dec 16, 2009 at 03:56:17PM -0800, Andrew Isaacson wrote:
>> With CONFIG_KPROBES=y on Ubuntu 9.10 x86_64 default install, I get the
>> following:
>>
>> Error: Your awk doesn't support charactor-class.
>> Please try to use gawk.
> 
> Aside of the incorrect suggestion (you need not just gawk, you need that
> thing installed as awk), the use of GNUisms in there is actually pointless
> since encoding is bloody fixed.

Hmm, maybe "POSIX awk" will be a better suggestion, isn't it?


Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

