Return-Path: <linux-kernel-owner+w=401wt.eu-S1766005AbYESNmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766005AbYESNmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765422AbYESNjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:39:24 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:9682 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765411AbYESNjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=T4V0oSrA6YH2i76exuQzZd001Gu2qGGKOYk54qhckAWsbUXC2D3VfcWjx3dVpqtAqYTDJX39MWI79h0WLoEiLEbiWV9iH1QvI8ZRWdRXlmvdlcQXouNZnLx6VCc8AIgzgDrAMBk1zzFPAafcgJdzK5OQ7wVJ+dSgO3DWCACuqFI=
Message-ID: <483182E6.1020709@gmail.com>
Date: Mon, 19 May 2008 15:38:46 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com
Subject: Re: [PATCH 01/10] modpost: add support for hid
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com> <Pine.LNX.4.64.0805191535071.6718@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0805191535071.6718@jikos.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2008 03:36 PM, Jiri Kosina wrote:
> On Fri, 16 May 2008, Jiri Slaby wrote:
>> Generate aliases for hid device modules to support autoloading.

> Hi Jiri,

Hi!

> thanks for rebasing the series and fixing the comments raised during 
> review.

BTW. this patch (01) needs fix. It breaks crossbuilds. I will repost the 01 
patch in few moments.

> However, I seem to miss the 10/10 patch from this series, and it doesn't 
> seem to be even in my lkml/linux-input folder.

:) It should have been X/9. The 10th patch is only my testing patch.
