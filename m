Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0BLWd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:33:57 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:58330 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab0BLWd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:33:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fr+VVNLU/lNq6X6ZqnodseM6echU3tzusSq51JqLFhHQqa6rJ5jnhFWmVXf5lmudZw
         3mRunHGTGb2aEJindaDkIDmCYmhxBR3QidNniM2U0Rl+zBXg4FyCrzr6DzJhaw60moSD
         sgxx+a4Y+FHBzAfgbmqOhJ+wvl1/idQ/TrbSw=
Message-ID: <4B75D752.1010904@lwfinger.net>
Date: Fri, 12 Feb 2010 16:33:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Bernhard Schiffner <bernhard@schiffner-limbach.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [mmiotrace] Make timestamps as printk() does.
References: <201002072205.26665.bernhard@schiffner-limbach.de>
In-Reply-To: <201002072205.26665.bernhard@schiffner-limbach.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2010 03:05 PM, Bernhard Schiffner wrote:
> Hallo,
> 
> this little patch makes a simple "sort -m" on output gotten from dmesg and  
> mmiotrace possible.
> It's a real help at least for me.
> 
> Bernhard
> (CC me please, I'am not on this list.)

NACK. This sort of transformation is best left to local tools.

Larry

